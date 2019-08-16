function [SG] = supergaussian(A, FWHM, Nx, Ny, dx, dy, n)
% Inputs: A = amplitude; FWHM = full width half max in metres; dx and dy
% are the resolutions in metres, Nx, Ny = scalars denoting size of desired 
% output array; n = Supergaussian order;

%% 0. Debug
% A = 1; FWHM = 4.3e-3; Nx = 1; Ny = 600; n = 8; dx = 20e-6; dy = dx;
% for exp(-2) radius of 4.3mm, FWHM = 4.3mm / 0.8493218 = 5.063e-3

%% 1. Function proper

if ~exist('n', 'var')
  n = 2;
end

x = linspace(-Nx/2, Nx/2-1, Nx).*dx;
y = linspace(-Ny/2, Ny/2-1, Ny).*dy;
[X, Y] = meshgrid(x, y);
[T, R] = cart2pol(X, Y);

G_mod = A.*exp(-(abs(R/(FWHM*(1/(2*(log(2)^(1/n)))))).^n)); % Decimal number is the conversion between exp(-2) and FWHM
[~, ~, SG] = pol2cart(T, R, G_mod);

% Definition of supergaussian and FWHM from
% https://www.atmos-meas-tech-discuss.net/amt-2016-307/amt-2016-307.pdf page 4

end