function [ LL LH HL HH ] = dwt2db97( image )
% Returns dwt2(image, 'db97'), but since db97 isn't implemented, it uses a
% separate function. This function just makes the returned values follow
% the same interface to when using the built-in dwt2.
%
% Requires file "wavecdf97.m" Download from:
% https://www.mathworks.com/matlabcentral/fileexchange/11846-cdf-97-wavelet-transform/content/wavecdf97.m

    transformed_image = wavecdf97(image, 1);
    
    [full_w, full_h] = size(transformed_image);
    half_w = full_w / 2;
    half_h = full_h / 2;
    
    LL = transformed_image(1:half_w, 1:half_h);
    LH = transformed_image(half_w:full_w, 1:half_h);
    HL = transformed_image(1:half_w, half_h:full_h);
    HH = transformed_image(half_w:full_w, half_h:full_h);

end

