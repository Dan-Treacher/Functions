function [Out_x2, Out_y2, C] = SecondMoment(Input)
% Output is \sigma^2, so to convert to exp(-2) radius in the corresponding
% dimension, you need to do: 2*sqrt(Out_x2)*pixelsize

%% 1. Check for dimensions
x = 1:size(Input,2);
y = (1:size(Input,1))';

% Calculate weighted centroid first, then do the second moment integral
if (length(x) > 1) && (length(y) > 1) % 2D image
  [~, C0] = FindCentroid(Input, 0.5, 1);
  C0 = round(C0);
  x0 = C0(1); % Weighted centroid in x
  y0 = C0(2); % Weighted centroid in y

  Sigma_x2 = trapz(y,trapz(x,((x-x0).^2).*Input,2))/trapz(y,trapz(x,Input,2));
  Sigma_y2 = trapz(x,trapz(y,((y-y0).^2).*Input,1))/trapz(y,trapz(x,Input,2));
else % If dimensions < 2 it must be a 1D line
  if size(Input,1) == 1 % x only
    [~, X0] = FindCentroid(Input, 0.5, 1);
    x0 = round(X0(1)); % Weighted centroid in x
    y0 = nan;
    
    Sigma_x2 = trapz(((x-x0).^2).*Input, 2)/trapz(Input, 2);
    Sigma_y2 = nan;
  else % y only
    [~, Y0] = FindCentroid(Input, 0.5, 1);
    y0 = round(Y0(2)); % Weighted centroid in y
    x0 = nan;
    
    Sigma_y2 = trapz(((y-y0).^2).*Input)/trapz(Input);
    Sigma_x2 = nan;
  end
end

Out_x2 = Sigma_x2;
Out_y2 = Sigma_y2;
C = [x0 y0];