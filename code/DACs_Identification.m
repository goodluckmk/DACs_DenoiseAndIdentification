% load data
res = 0.021;
im = imread('datasets/exp_test/YSc1_fake_B.png');
im = im(:,:,1);
im2 = imread('datasets/exp_test/YSc1_real_A.png');
im2 = im2(:,:,1);
montage({im,im2})
%% localize atomic-sites
thres = multithresh(im,10);
mask = im>thres(4);
stats = regionprops(mask);
i = find([stats.Area]>3);
stats2 = stats(i);

centers = [];
for i=1:size(stats2,1)
    center = stats2(i).Centroid;
    centers(i,:) = center;
end
figure; 
imshow(im);
hold on;
% 绘制未匹配的点（黄色圆点）
plot(centers(:,1), centers(:,2), 'y.', ...
    "Marker","o",'MarkerSize', 7,'LineWidth', 1);
title('sites localization');
xlabel('X axis');
ylabel('Y axis');
grid on;
axis equal;
hold off
%% identify atomic-sites' intensities
r = 4;
mean_vals = [];
for i=1:size(centers,1)
    mask = zeros(256,256,'uint8');
    [x,y] = meshgrid(1:256, 1:256);
    mask( (y-centers(i,1)).^2 + (x-centers(i,2)).^2 <= r.^2 ) = 1;
    mean_val = sum(im.*mask,'all');
    mean_vals = cat(1,mean_vals,mean_val);
end
[sorted_means,ind] = sort(mean_vals);

%% 1. get neighber sites
d = 0.354/res;
[neighbors, dists] = rangesearch(centers, centers, d*1.2);
%% 2. set intensity threshold
n = size(centers,1);
n1 = round(n*0.15);
n2 = round(n*0.85);   
indensity_thres = std(sorted_means(n1:n2));
%%  3. potential pairs (i < j)
valid_pairs = [];
valid_dists = [];
for i = 1:length(neighbors)
    % all neighbor sites
    for k = 1:length(neighbors{i})
        j = neighbors{i}(k);
        if j > i
            % get intensity gap
            int_diff = abs(mean_vals(i) - mean_vals(j));
            % intensity gap > std
            if int_diff > indensity_thres
                valid_pairs = [valid_pairs; i, j];
                valid_dists = [valid_dists; dists{i}(k)];
            end
        end
    end
end
%% 4. Sort potential pairs by distance from smallest to largest
[sorted_dists, sort_idx] = sort(valid_dists);
sorted_pairs = valid_pairs(sort_idx, :);
%% 5. Greedy algorithm matching (preferentially matches the closest unoccupied point pair)
matched = false(size(centers, 1), 1);
matches = [];
for k = 1:size(sorted_pairs, 1)
    i = sorted_pairs(k, 1);
    j = sorted_pairs(k, 2);
    if ~matched(i) && ~matched(j)
        matches = [matches; [i, j]];
        matched(i) = true;
        matched(j) = true;
    end
end
%% 6.result show
figure; 
imshow(im);
hold on;
% plot unmatched sites
matched_indices = unique(matches(:));
unmatched_indices = setdiff(1:size(centers,1), matched_indices);
plot(centers(unmatched_indices,1), centers(unmatched_indices,2), 'y.', ...
    "Marker","o",'MarkerSize', 7,'LineWidth', 1);
% plot matched sites
plot(centers(matched_indices,1), centers(matched_indices,2), 'g.', ...
    "Marker","o",'MarkerSize', 7,'LineWidth', 1);

% plot unmatched pair
for k = 1:size(matches, 1)
    i = matches(k, 1);
    j = matches(k, 2);
    plot([centers(i,1), centers(j,1)], [centers(i,2), centers(j,2)], ...
        'g-', 'LineWidth', 1.5);
end

title('result show');
xlabel('X axis');
ylabel('Y axis');
grid on;
axis equal;
hold off;
DAC_Number = size(matched_indices,1)
SAC_Number = size(unmatched_indices,2)