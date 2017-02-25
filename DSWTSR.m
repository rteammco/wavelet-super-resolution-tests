function [ sr_image ] = DSWTSR( lr_image )
% Discrete and Stationary Wavelet Transform Super-Resolution.
% Based on the paper "Image Resolution Enhancement by Using Discrete and
% Stationary Wavelet Decomposition" (2011).
    
    wavelet_filter = 'haar';  % TODO: Daubechies 9/7?
    interpolation_method = 'bicubic';
    swt_level = 1;

    [~, ~, depth] = size(lr_image);
    if depth ~= 1
        lr_image = rgb2gray(lr_image);
    end
    
    % DWT, and upsample the high-frequency subbands.
    [~, dLH, dHL, dHH] = dwt2(lr_image, wavelet_filter);
    %dLL = imresize(dLL, size(lr_image), interpolation_method);
    dLH = imresize(dLH, size(lr_image), interpolation_method);
    dHL = imresize(dHL, size(lr_image), interpolation_method);
    dHH = imresize(dHH, size(lr_image), interpolation_method);
    
    % SWT.
    [~, sLH, sHL, sHH] = swt2(lr_image, swt_level, wavelet_filter);
    
    % Combine the interpolated DWT high-frequency subbands with the SWT
    % high-frequency subbands.
    % Dividing by 2 seems to work better.
    LH = (dLH + sLH) / 2;
    HL = (dHL + sHL) / 2;
    HH = (dHH + sHH) / 2;
    
    % Get resulting SR image using inverse DWT on the combined
    % high-frequency subbands, and using the original image as the
    % low-frequency subband.
    % Multiplying the lr_image by 2 scales it to the LL intensity range,
    % which is 0 to 2.
    sr_image = idwt2(lr_image * 2, LH, HL, HH, wavelet_filter);

end

