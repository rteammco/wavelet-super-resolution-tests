function [ img ] = addNoise( img, sigma )
% Adds noise to the given image (assuming values approx. between 0 and 1).
% Sigma is the Guassian noise sigma value.

    img = img + sigma * randn(size(img));

end

