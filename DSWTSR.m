function [ sr_image ] = DSWTSR( lr_image )
% Discrete and Stationary Wavelet Transform Super-Resolution.
% Based on the paper "Image Resolution Enhancement by Using Discrete and
% Stationary Wavelet Decomposition" (2011).
    
    wavelet_filter = 'db37';  % TODO: Daubechies 9/7?
    interpolation_method = 'bicubic';
    swt_level = 1;

    [~, ~, depth] = size(lr_image);
    if depth ~= 1
        lr_image = rgb2gray(lr_image);
    end
    
    % DWT, and upsample the high-frequency subbands.
    [~, dLH, dHL, dHH] = dwt2(lr_image, wavelet_filter);
    dLH = imresize(dLH, size(lr_image), interpolation_method);
    dHL = imresize(dHL, size(lr_image), interpolation_method);
    dHH = imresize(dHH, size(lr_image), interpolation_method);
    
    % SWT.
    [~, sLH, sHL, sHH] = swt2(lr_image, swt_level, wavelet_filter);
    
    % Combine the interpolated DWT high-frequency subbands with the SWT
    % high-frequency subbands.
    LH = dLH + sLH;
    HL = dHL + sHL;
    HH = dHH + sHH;
    
    % Get resulting SR image using inverse DWT on the combined
    % high-frequency subbands, and using the original image as the
    % low-frequency subband.
    sr_image = idwt2(lr_image, LH, HL, HH, wavelet_filter);

end

