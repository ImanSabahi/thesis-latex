function cmap = parula80(n)
    % parula80: Returns a colormap that uses the first 80% of MATLAB's parula colormap.
    % 
    % Usage: cmap = parula80(n)
    %   n - Number of desired colors (optional, default is 64)
    % 
    % Example: 
    %   colormap(parula80)
    %
    
    if nargin < 1
        n = 64; % Default number of colors if not specified
    end
    baseColormap = parula(ceil(n * 256)); % Generate more colors than needed
    cmap = baseColormap(1:round(0.8 * size(baseColormap, 1)), :); % Keep 80% of them
    cmap = interp1(1:size(cmap, 1), cmap, linspace(1, size(cmap, 1), n), 'linear'); % Interpolate to n colors
end