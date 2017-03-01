function [ sr_image ] = DSWTSR( lr_image, scale_alpha )
% Discrete and Stationary Wavelet Transform Super-Resolution.
% Based on the paper "Image Resolution Enhancement by Using Discrete and
% Stationary Wavelet Decomposition" (2011).
%
% scale_alpha = the upsampling scale (e.g. 2 for 2x enlargement).
    
    dwt_wavelet_filter_fwd = 'db9';
    swt_wavelet_filter_fwd = 'db9';
    dwt_wavelet_filter_inv = 'db9';
    interpolation_method = 'bicubic';
    swt_level = 1;

    [~, ~, depth] = size(lr_image);
    if depth ~= 1
        error('Currently only grayscale images are supported.');
    end
    
    % DWT, and upsample the high-frequency subbands.
    [~, dLH, dHL, dHH] = dwt2(lr_image, dwt_wavelet_filter_fwd);
    dLH = imresize(dLH, size(lr_image), interpolation_method);
    dHL = imresize(dHL, size(lr_image), interpolation_method);
    dHH = imresize(dHH, size(lr_image), interpolation_method);
    
    % SWT.
    [~, sLH, sHL, sHH] = swt2(lr_image, swt_level, swt_wavelet_filter_fwd);
    
    % Combine the interpolated DWT high-frequency subbands with the SWT
    % high-frequency subbands.
    %LH = (dLH + sLH) / 2;
    %HL = (dHL + sHL) / 2;
    %HH = (dHH + sHH) / 2;
    LH = dLH + sLH;
    HL = dHL + sHL;
    HH = dHH + sHH;
    
    % Upsample all of the components.
    % Multiplying the lr_image by 2 scales it to the LL intensity range,
    % which is 0 to 2.
    %sr_image = idwt2(lr_image * 2, LH, HL, HH, wavelet_filter_inv);
    LL = imresize(lr_image, scale_alpha / 2, interpolation_method) * 2;
    LH = imresize(LH, scale_alpha / 2, interpolation_method);
    HL = imresize(HL, scale_alpha / 2, interpolation_method);
    HH = imresize(HH, scale_alpha / 2, interpolation_method);
    
    % Get resulting SR image using inverse DWT on the combined
    % high-frequency subbands, and using the original image as the
    % low-frequency subband.
    sr_image = idwt2(LL, LH, HL, HH, dwt_wavelet_filter_inv);

end

