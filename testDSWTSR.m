img_file_name = 'nyc_rooftops.jpg';

if ~exist('img')
    img = imread(['test_images/' img_file_name]);
    img = rgb2gray(img);
    img = imresize(img, [500, 500]);
    img = im2double(img);
    disp('Loaded image.');
end

img_small = imresize(img, 0.5, 'bicubic');

img_upsampled = imresize(img_small, 2, 'bicubic');
[psnr_upsampled, ~] = psnr(img_upsampled, img);

img_sr = DSWTSR(img_small);
[psnr_sr, ~] = psnr(img_sr, img);

subplot(2, 2, 1);
imshow(img_small);
title('Original');

subplot(2, 2, 2);
imshow(img);
title('Ground Truth');

subplot(2, 2, 3);
imshow(img_upsampled);
title(['Upsampled (' num2str(psnr_upsampled) ')']);

subplot(2, 2, 4);
imshow(img_sr);
title(['Super-Resolved (' num2str(psnr_sr) ')']);