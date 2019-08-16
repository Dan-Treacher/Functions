function [Z_out] = ZernikeGeneration(A, Zm, Zn, R_beam, dx, CP)
%% Zernike polynomial generating functions
% Inputs:
% A = Array of zeros within which the polynomial will be made
% Zn = Radial component order (n >= m in the radial polynomial, but not necessarily wrt Z indices)
% Zm = Azimuthal component frequency
% R_beam = Radius of the unit circle upon which the polynomials are calculated (take the exp(-2) radius as a guideline) [m]
% dx = Resolution of the grid [m]
% CP = Centre point, supplied in a pixel pair offset from centre: [x,y]

%% Debug
%A = zeros(600,792); Zm = -2; Zn = 4; R_beam = 4.3e-3; CP = [0,0];

%% 1. Axes

% SLM details
[Ny, Nx] = size(A);
dx = dx; dy = dx; % Resolution of the SLM [m]

y = ((-(Ny/2)+1)-CP(2):(Ny/2)-CP(2)).*dy; % Actual span of the SLM [m]
x = ((-(Nx/2)+1)-CP(1):(Nx/2)-CP(1)).*dx;

% SLM axes scaled to the beam radius (normalised units such that now the
% edge of the unit circle corresponds to R_beam)
yy = y.*(1/R_beam);
xx = x.*(1/R_beam);

% 2D axes
[X, Y] = meshgrid(xx, yy);
Rad = X.^2 + Y.^2 < 1^2; % 1 == unit circle in units now scaled by exp(-2) radius of the beam
[Theta, Rho] = cart2pol(X, Y);

%% 2. Generating function

% Summation endpoint
k_end = (Zn - abs(Zm))/2; % Starting and finishing points for the summation
R = zeros(size(A)); % Pre-allocate the array for the radial component

if Zm >= 0 % Even polynomials
    n = Zn; m = Zm; % This is here bc the radial polynomial only takes positive integer values of n,m
    R_gen = @(k, n, m) ((((-1)^k)*factorial(n-k))/(factorial(k)*factorial(((n+m)/2)-k)*factorial(((n-m)/2)-k))).*Rho.^(n-(2*k)); % Radial gen fn
    for k = 0:k_end
        R_new = R_gen(k, n, m);
        R = R + R_new; % Radial part
    end
    Az = cos(Theta.*m); % Azimuthal part
    Z = R.*Az;

else % Odd polynomials
    n = Zn; m = abs(Zm);
    R_gen = @(k, n, m) ((((-1)^k)*factorial(n-k))/(factorial(k)*factorial(((n+m)/2)-k)*factorial(((n-m)/2)-k))).*Rho.^(n-(2*k));
    for k = 0:k_end
        R_new = R_gen(k, n, m);
        R = R + R_new; % Radial part
    end
    Az = sin(Theta.*m); % Azimuthal part
    Z = R.*Az;

end

Z_out = Z.*Rad; % Polynomial outside of the unit circle diverges to strange values and isn't very useful
%figure(1); mesh(Z_out); view(2); daspect([1,1,1]); axis tight
%figure(1); mesh(Z); view(2); daspect([1,1,1]); axis tight

end

