function [strictMask] = makeStrictMask(mask, radius)

if nargin < 2
    radius = 2; % default radius
end

[rows, cols] = size(mask);
strictMask = false(rows, cols);  % initialize new mask

% Pad the mask to handle edge cases
paddedMask = padarray(mask, [radius, radius], 0);

for x = 1:rows
    for y = 1:cols
        if mask(x, y)
            % Get local patch centered at (x,y)
            localPatch = paddedMask(x:x+2*radius, y:y+2*radius);
            if all(localPatch(:))  % all surrounding pixels are foreground
                strictMask(x, y) = true;
            end
        end
    end
end
