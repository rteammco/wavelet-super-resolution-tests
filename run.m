% Constants. Define as needed.
filter = 'haar';
img_file_name = 'cell.jpg'

% Read image, convert to gray, resize to fixed size.
if ~exist('img')
    img = imread(['test_images/' img_file_name]);
    img = rgb2gray(img);
    img = imresize(img, [500, 500]);
    img = im2double(img);
    disp('Loaded image.');
end

% DWT of the original image.
[LL_orig, LH_orig, HL_orig, HH_orig] = dwt2(img, filter);

% Recovered original image.
img_recovered = idwt2(LL_orig, LH_orig, HL_orig, HH_orig, filter);

% Downsample. This is the "input" image.
img_small = imresize(img, 0.5, 'bilinear');

% Upsample. This is for regular upsampling comparison.
img_upsampled = imresize(img_small, 2, 'bilinear');
[psnr_upsampled, ~] = psnr(img_upsampled, img);

% DWT of the small image.
[LL_small, LH_small, HL_small, HH_small] = dwt2(img_small, filter);

% Upsample each DWT component.
dwt_upsampling_mode = 'bilinear';
LL_upsampled = imresize(LL_small, 2, dwt_upsampling_mode);
LH_upsampled = imresize(LH_small, 2, dwt_upsampling_mode);
HL_upsampled = imresize(HL_small, 2, dwt_upsampling_mode);
HH_upsampled = imresize(HH_small, 2, dwt_upsampling_mode);
LL_upsampled = LL_orig;
%LH_upsampled = LH_orig;
%HL_upsampled = HL_orig;
%HH_upsampled = HH_orig;

% IDWT of the upsampled.
img_dwt_upsampled = idwt2(LL_upsampled, LH_upsampled, HL_upsampled, HH_upsampled, filter);
img_dwt_upsampled = imresize(img_dwt_upsampled, size(img));
[psnr_dwt_upsampled, ~] = psnr(img_dwt_upsampled, img);

%%%%% DISPLAY %%%%%

subplot(2, 3, 1);
imshow(img);
title('Original Image');

subplot(2, 3, 2);
imshow(getWaveletImage(LL_orig, LH_orig, HL_orig, HH_orig));
title('Original DWT');

subplot(2, 3, 3);
imshow(img_upsampled);
title(['Bilinear Upsampling (' num2str(psnr_upsampled) ')']);

subplot(2, 3, 4);
imshow(getWaveletImage(LL_small, LH_small, HL_small, HH_small));
title('DWT');

subplot(2, 3, 5);
imshow(getWaveletImage(LL_upsampled, LH_upsampled, HL_upsampled, HH_upsampled));
title('Upsampled DWT');

subplot(2, 3, 6);
imshow(img_dwt_upsampled);
title(['Recovered Upsampled DWT (' num2str(psnr_dwt_upsampled) ')']);