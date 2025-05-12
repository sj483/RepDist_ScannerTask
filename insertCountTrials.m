function [newArray]= insertCountTrials(permdRunOrder)
insertVal = 55;
blockSize = 57;
original = permdRunOrder;  % assuming it has 270 elements
nBlocks = length(original) / blockSize;

% Preallocate the new array (only nBlocks - 1 insertions of 55)
newLength = length(original) + (nBlocks - 1);
newArray = zeros(newLength, 1);

% Use indexing to fill newArray
origIdx = 1;
newIdx = 1;

for i = 1:nBlocks
    newArray(newIdx:newIdx+blockSize-1) = original(origIdx:origIdx+blockSize-1);
    origIdx = origIdx + blockSize;
    newIdx = newIdx + blockSize;
    
    % Only insert 55 if not the last block
    if i < nBlocks
        newArray(newIdx) = insertVal;
        newIdx = newIdx + 1;
    end
end
