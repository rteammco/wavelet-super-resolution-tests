img_file_name = 'lena.jpg';

if ~exist('img')
    img = imread(['test_images/' img_file_name]);
    img = rgb2gray(img);
    img = imresize(img, [512, 512]);
    img = im2double(img);
    disp('Loaded image.');
end

scale = 4;
img_small = imresize(img, 1.0 / scale, 'bicubic');

% Run the DSWT Super-Resolution code.
img_sr = DSWTSR(img_small, scale);
disp(['Sizes: ' mat2str(size(img_sr)) ' vs. ' mat2str(size(img))]);
img_compare = imresize(img, size(img_sr), 'bicubic');
[psnr_sr, ~] = psnr(img_sr, img_compare);

% Compare to upsampled version.
img_upsampled = imresize(img_small, size(img_sr), 'bicubic');
[psnr_upsampled, ~] = psnr(img_upsampled, img_compare);

subplot(2, 2, 1);
imshow(img_small);
title('Low-Resolution Original');

subplot(2, 2, 2);
imshow(img);
title('Ground Truth');

subplot(2, 2, 3);
imshow(img_upsampled);
title(['Upsampled (' num2str(psnr_upsampled) ')']);

subplot(2, 2, 4);
imshow(img_sr);
title(['Super-Resolved (' num2str(psnr_sr) ')']);