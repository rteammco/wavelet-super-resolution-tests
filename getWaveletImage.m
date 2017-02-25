function [ img ] = getWaveletImage( LL, LH, HL, HH )
% Returns an image of the four wavelet components stitched together.
% The components are normalized between 0 and 1 to provide better
% visualization.

    %LL = LL - min(LL(:));
    LL = LL / max(LL(:));
    
    LH = LH - min(LH(:));
    LH = LH / max(LH(:));
    
    HL = HL - min(HL(:));
    HL = HL / max(HL(:));
    
    HH = HH - min(HH(:));
    HH = HH / max(HH(:));
    
    img = [LL LH; HL HH];

end

