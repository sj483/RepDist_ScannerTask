function [imgId,isTarget] = getImgId(trigId)
% Inverse of getTrigId: maps trigId -> imgId and isTarget

% Check inputs
if ~isnumeric(trigId)
    error('Bad inputs');
end

% Cast to cell array
trigId = num2cell(trigId);

% Convert to binary strings (8 bits total: 1 + 4 + 3)
trigBin = cellfun(@(ii){dec2bin(ii,8)},trigId);

% Extract parts
isTargetStr = cellfun(@(s){s(1)},trigBin);
catIdStr    = cellfun(@(s){s(2:5)},trigBin);
imgNumStr   = cellfun(@(s){s(6:8)},trigBin);

% Convert back to numeric values
isTarget = cellfun(@(s){str2double(s)},isTargetStr);
catId    = cellfun(@(s){bin2dec(s)},catIdStr);
imgNum   = cellfun(@(s){bin2dec(s)},imgNumStr);

% Combine to form imgId
imgId = cellfun(@(c,n){6*c + n+1},catId,imgNum);

% Unwrap from cells
imgId = cell2mat(imgId);
isTarget = cell2mat(isTarget);
return