function SLM = GenSLM(lambda, f, N_y, N_x, dx)
% Use this to quickly load the SLM structure, once you've specified the
% experiment wavelength and focal length

% This gives you the option to crank up the grid size to see stuff in the fourier space
if nargin < 3
  SLM.Ny = 600; % If it's not specified, leave it as default
else
  SLM.Ny = N_y;
end

if nargin < 4
  SLM.dx = 20e-6; SLM.dy = 20e-6; % Resolutions [m]
else
  SLM.dx = dx; SLM.dy = SLM.dx;
end

% Other things
SLM.AR = (N_x/N_y); % Aspect ratio of the SLM - keep this constant
SLM.Nx = N_x; % Numbers of pixels
SLM.Lx = SLM.dx*SLM.Nx; SLM.Ly = SLM.dy*SLM.Ny; % Record lengths [m]
SLM.dX = (lambda*f)/(SLM.Lx); SLM.dY = (lambda*f)/(SLM.Ly); % Fourier space resolutions [m]
SLM.Face = zeros(SLM.Ny, SLM.Nx); % Just a template so you can quickly define other sized grids

end