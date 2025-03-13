# DACs_DenopiseAndIdentification
a algorithm workflow for high quality DACs HAADF-STEM image denoising and identification
## System Requirements
The matlab package are created in MATLAB 2023b.

The pix2pix we refered is available for download at "https://github.com/junyanz/pytorch-CycleGAN-and-pix2pix".

This package only requires a standard computed with sufficient RAM (8GB+) to reproduce the experimental results.

## User Guide
1.The simulated datasets of pix2pix are genarated from the code "SimuADCs.m" and "SimuADCs_Batch.m".
Sample images can be seen from the "simu_montage" folder.

2.The denoised effect of pix2pix (simulated data not involved in training) can be viewed by folder "pix2pix_simu_result",
where "i_real_A.png"  denotes the raw image, "i_fake_B.png" denotes the denoised image, and "i_real_B.png" denotes the reference image.

3.DACs identification can be realized by code "DACs_Identification.m" step by step. The result can be shown in "show_image" folder.
you can get input data from folder "exp_test".

4.The well trained checkpoints of pix2pix can be download at "https://figshare.com/articles/dataset/DACs_DenopiseAndIdentification/28586777", 
and the pix2pix network we use is available for download at ‘https://github.com/junyanz/pytorch-CycleGAN-and-pix2pix’.

# License

This project is covered under the **MIT License**.
