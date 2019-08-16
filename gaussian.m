function [G, X, Y] = gaussian(A, w, Nx, Ny, dx, dy, CP, n)
% Inputs: 
% A = amplitude
% w = exp(-2) radius
% Nx, Ny = scalars denoting size of desired output array
% dx,y are the resolutions in each axes. If you enter 'w' in metres, then 
%   obviously, you need to specify the values of dx and dy. Leave them 
%   blank if they can be '1' and you've specified w in pixels
% CP = 1,2 matrix with desired coordinates of gaussian centre. 
%   Leave blank if centre of Nx, Ny is fine
% n = supergaussian exponent

% Outputs: G = output gaussian; X = X axis if you specified dx and Y = Y
% axis if you specified dy

%% Variable check

if ~exist('CP', 'var')
  CP = [0, 0]; % If no centre point in specified, call it zero
end

if ~exist('n', 'var')
  n = 2; % If no supergaussian exponent is specified, call it 2
end  

Lx = dx * Nx; Ly = dy * Ny;
x = linspace(-Lx/2, Lx/2-dx, Nx);
y = linspace(-Ly/2, Ly/2-dy, Ny);
[X, Y] = meshgrid(x, y);
G = A.*exp(-2*(abs(sqrt((X-CP(1,1)).^2+(Y+CP(1,2)).^2)/w).^n));

end

