function [Mask, S] = Vortex(Nx, Ny, dx, dy, Rmax, N, L1, dL)
%% Inputs:
% Nx = number of pixels in the array horizontally
% Ny = number of pixels in the array vertically
% dx = resolution in the horizontal direction
% dy = resolution in the vertically direction
% Rmax = outermost extent of the vortex (6mm is a good start for w_in = 4.3e-3)
% N = number of radial zones (more = larger separation between foci)
% L1 = topological charge of the innermost starting zone
% dL = rate of change of topological charge from one radial zone to the next (foci rotation rate held constant iff this is constant)

%% Outputs:
% Mask = uint8 phase map ready to be saved and displayed
% S = Mask before conversion to uint8

%% 1. Build axes

% 1D
x = ((-Nx/2)+1:Nx/2).*dx;
y = ((-Ny/2)+1:Ny/2).*dy;

% 2D
[X, Y] = meshgrid(x, y);
[T, R] = cart2pol(X, Y);

%% 2. Properties of the vortex

% Topological charges for the N different radial zones
Ln = zeros(1,N);
for n = 1:N
  Ln(n) = L1 + (n-1)*dL;
  %Ln(n) = 1 + (n-1)*2;
end

% Logic masks for the different zones and the actual exp function
R_zones = cell(1,N+1);
S = zeros(Ny, Nx);
for n = 1:N
  R_zones{n} = R < Rmax*sqrt(n/N) & R > Rmax*sqrt((n-1)/N);
  R_zones{end} = R > Rmax*sqrt((n)/N);
  S = S + exp(T.*1i*Ln(n)).*R_zones{n};
end

%% 3. Define output (S is raw, Mask is uint8 bmp and ready to be saved)

Mask = angle(S) - min(angle(S(:)));
Mask(R_zones{end}) = 0; % Stops the vertically symmetric central stuff from raising the outer floor
Mask = uint8(Mask.*(255/(max(Mask(:)))));

end
