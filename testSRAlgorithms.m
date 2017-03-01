% Runs the implemented wavelet-based SR algorithms and compares them.

img_file_name = 'lena.jpg';
scale = 8;

% Load file if not already loaded.
if ~exist('img')
    img = imread(['test_images/' img_file_name]);
    img = rgb2gray(img);
    img = imresize(img, [512, 512]);
    img = im2double(img);
    disp('Loaded image.');
end

% Generate the LR image.
img_small = imresize(img, 1.0 / scale, 'bicubic');

% Do upsampling for comparison.
img_upsampled = imresize(img_small, size(img), 'bicubic');
[psnr_upsampled, ~] = psnr(img_upsampled, img);

% Run the DSWT Super-Resolution code.
img_sr_1 = DSWTSR(img_small, scale);
disp(['Sizes: ' mat2str(size(img_sr_1)) ' vs. ' mat2str(size(img))]);
img_compare = imresize(img, size(img_sr_1), 'bicubic');
[psnr_sr_1, ~] = psnr(img_sr_1, img_compare);

% Run the WBIRE Super-Resolution code.
img_sr_2 = WBIRE(img_small, scale);
disp(['Sizes: ' mat2str(size(img_sr_2)) ' vs. ' mat2str(size(img))]);
img_compare = imresize(img, size(img_sr_2), 'bicubic');
[psnr_sr_2, ~] = psnr(img_sr_2, img_compare);

subplot(2, 3, 1);
imshow(img);
title('Ground Truth');

subplot(2, 3, 2);
imshow(img_small);
title('Low-Resolution Original');

subplot(2, 3, 3);
imshow(img_upsampled);
title(['Upsampled (' num2str(psnr_upsampled) ')']);

subplot(2, 3, 4);
imshow(img_sr_1);
title(['SR DSWT (' num2str(psnr_sr_1) ')']);

subplot(2, 3, 5);
imshow(img_sr_2);
title(['SR WBIRE (' num2str(psnr_sr_2) ')']);