function [trigId] = getTrigId(imgId,isTarget)

% Check inputs
if ~isnumeric(imgId) || ~(isnumeric(isTarget) || islogical(isTarget))
    error('Bad inputs');
end
if any(size(imgId)~=size(isTarget)) && (numel(isTarget)>1)
    error('Dimensions of input are not compatible;');
end

% Expand isTarget if needed
if numel(imgId) > numel(isTarget)
    isTarget = isTarget.*ones(size(imgId));
end

% Cast inputs as cell arrays
imgId = num2cell(imgId);
isTarget = num2cell(isTarget);

% isTarget: {0/false,1/true} -> {"0","1"}
isTarget = cellfun(@(ii){num2str(ii)},isTarget);

% catId ∈ {0,1...8} [expressed in binary]
catId = cellfun(@(ii){dec2bin(floor(ii/6),4)},imgId);

% imgNum ∈ {0,1...5} [expressed in binary]
imgNum = cellfun(@(ii){dec2bin(mod(ii,6),3)},imgId);

% Put it all together
trigId = cellfun(@(s1,s2,s3){[s1,s2,s3]},isTarget,catId,imgNum);

% Convert binary to double 
trigId = cellfun(@bin2dec,trigId);
return