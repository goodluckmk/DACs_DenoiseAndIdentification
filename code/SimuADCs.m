%% parameters settings
numPoints = randi([40 100]);
minDist = 1; 
block = randi([1 2])*32;
r=2;
%% background simulation
bg = zeros(256,256,"uint8");
numBlock = 256/block;
color_block = 30;
for i=1:numBlock
    for j=1:numBlock
        min_ = randi([5 40]);
        max_ = min_ + 40;
        bg((i-1)*block+1:i*block, (j-1)*block+1:j*block) = randi([min_ max_],block);
    end
end
bg = imgaussfilt(bg,10); 
vars = {'color_block','i','j','min_','max_'};
clear(vars{:})
%% get atomic sites

points = zeros(numPoints,2);

for i = 1:numPoints

    x = randi([6 250]);
    y = randi([6 250]);
    
    valid = true; 
    for j = 1:i-1
        dist = sqrt((x-points(j,1))^2 + (y-points(j,2))^2);
        if dist < minDist
            valid = false;
            break;
        end
    end
    
    if valid
        points(i,:) = [x y];
    end  
end
idx = find(points(:,1)==0 & points(:,2)==0);
points(idx,:) = [];
vars = {'i','x','y','valid','dist','idx','j'};
clear(vars{:})
%% print atomic sites
fg = zeros(256,256,"uint8");

for i = 1:size(points,1)
    color = randi([80,200]);
   [x,y] = meshgrid(1:256, 1:256);
   fg( (x-points(i,1)).^2 + (y-points(i,2)).^2 <= r.^2 ) = color;
end
fg = imgaussfilt(fg,1);
vars = {'i','x','y','color'};
clear(vars{:})
%% generating noise image
se = strel('disk',1);
I = fg+bg;
num_p = randi([5,15]);
In = imnoise(I,"gaussian");
for i=1:num_p
    In = imnoise(In,'poisson'); 
end
vars = {'i','se','num_p'};
clear(vars{:})
%% generating denoised image
Ind = imnoise(I,'gaussian',0,0.005);
Ind = imnoise(Ind,'poisson');
Ind = imgaussfilt(Ind);
se = strel('disk',7);
Ind = imtophat(Ind,se);
Ind = imgaussfilt(Ind);
imshow(Ind)
%% showpair
montage({In,Ind})
