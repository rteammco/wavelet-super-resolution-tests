function [ image ] = idwt2db97( LL, LH, HL, HH )
% Returns idwt2(image, 'db97') (the inverse of dwt2db97).
%
% Requires file "wavecdf97.m" Download from:
% https://www.mathworks.com/matlabcentral/fileexchange/11846-cdf-97-wavelet-transform/content/wavecdf97.m

    wavelet_image = [LL LH; HL HH];
    image = wavecdf97(wavelet_image, -1);

end

