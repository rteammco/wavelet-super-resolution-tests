function [ sr_image ] = WBIRE( lr_image, scale )
% "Wavelet-Based Image Resolution Enhancement" algorithm based on the paper
% "Discrete Wavelet Transform-Based Satellite Image Resolution Enhancement"
% (2013).
%
% scale = the upsampling scale (e.g. 2 for 2x enlargement).

    filter = 'haar';
    interpolation_method = 'bicubic';
    
    % DWT and interpolate each coefficient.
    [LL, LH, HL, HH] = dwt2(lr_image, filter);
    LL = imresize(LL, 2, interpolation_method);
    LH = imresize(LH, 2, interpolation_method);
    HL = imresize(HL, 2, interpolation_method);
    HH = imresize(HH, 2, interpolation_method);
    
    % Compute diff image. We rescale lr_image in case there are some size
    % differences due to the DWT filter choice. Multiply it by 2 to scale
    % to the correct pixel intensity values.
    lr_image = 2 * imresize(lr_image, size(LL), interpolation_method);
    diff_image = lr_image - LL;
    
    % Add the diff image to the high-frequency coefficients.
    LH = LH + diff_image;
    HL = HL + diff_image;
    HH = HH + diff_image;
    
    % Interpolate to the appropriate scale.
    LL = imresize(lr_image, scale / 2, interpolation_method);
    LH = imresize(LH, scale / 2, interpolation_method);
    HL = imresize(HL, scale / 2, interpolation_method);
    HH = imresize(HH, scale / 2, interpolation_method);
    
    % IWDT to finish.
    sr_image = idwt2(LL, LH, HL, HH, filter);

end

