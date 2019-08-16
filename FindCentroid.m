%% Function to find the centroids of an image of a beam
function [Geometric_Centroid, Weighted_Centroid, T] = FindCentroid(BeamImage, Threshold, FilterArea)
% BeamImageeam image = Image of the beam...
% Threshold  = 0 < scalar < 1 above which you take your signal to be legit
% FilterArea = Length of pixel square that's used to smooth the image. Smaller is faster

%% Debug
%BeamImage = Input; Threshold = 0; FilterArea = 1;

%% 0. Argument check

if nargin < 2 || isempty(Threshold)
  Threshold = 0.25;
end

%% 1. Filter and label image to reduce contribution from noise

BeamImage = medfilt2(BeamImage, [FilterArea,FilterArea]); % Slowest line. Speed up with a smaller smoothing area
T = BeamImage > Threshold*max(BeamImage(:)); T = imfill(T, 'holes'); % Threshold the smoothed image
L = bwconncomp(T); % Label the image components

%% 2. Loop through the pixel groups that don't comprise the main signal
% (Identified as all elements of the list L.PixelIdxList after the first entry as this is the longest one)

for j = 2:L.NumObjects
  T(L.PixelIdxList{j}) = 0; % Get rid of any stray dots, keep only the main signal
end

%% 3. Convert logical array into vector to extract thresholded gray array

S = regionprops(mat2gray(double(T)), double(T).*BeamImage, 'centroid', 'PixelIdxList', 'WeightedCentroid');
Geometric_Centroid = round(S.Centroid);
Weighted_Centroid = S.WeightedCentroid;
