function [stimTable] = getStimTable(imgPerm)

% Make sure imgPerm is valid! (1-ordered + group contiguous)
if nargin < 1
    % Generate a valid imgPerm if testing (this is subject specific)
    imgPerm = cellfun(@(iC) iC + (randperm(6)'),...
        num2cell(6*(randperm(9)-1)),'UniformOutput',false);
    imgPerm = reshape(cell2mat(imgPerm),54,1);
else
    M = kron(eye(9),ones(1,6)./6);
    a = M*imgPerm;
    fail = sum((sort(a)-(3.5:6:51.5)').^2) > 1e-16;
    if fail
        error('Invalid slotPerm input.');
    end
end

% Get the imgFns
imgFn = dir('./Imgs/Typicals/*.png');
imgFn = {imgFn.name}';

% Get the file paths
path_typ = ...
    fullfile('.',filesep,'Imgs',filesep,'Typicals',filesep,imgFn);
path_odd = ...
    fullfile('.',filesep,'Imgs',filesep,'Oddballs',filesep,imgFn);

% Get the imgIds
imgId = imgFn2imgId(imgFn);

% Get the catIds
catId = imgId2catId(imgId);

% Get the trigger IDs
trgId_typ = getTrigId(imgId,0);
trgId_odd = getTrigId(imgId,1);

% Create the unsorted stimList
stimTable = table(imgId,catId,imgFn,path_typ,path_odd,trgId_typ,trgId_odd);

% Sort the rows of the table
stimTable = stimTable(imgPerm,:);

% Add information from oddballDist
oddDist = load('oddballDist.mat');
oddDist = oddDist.oddballDist;
oddPlace = cell(size(oddDist,1),1);
for ii = 1:size(oddDist,1)
    v = oddDist(ii,:)';
    cIdx = find(v);
    runIdx = floor((cIdx-1)/5) + 1;
    repIdx = mod(cIdx-1,5) + 1;
    % posIdx = (3+54+1).*mod(cIdx-1,5) + ii;
    oddPlace{ii} = [runIdx,repIdx];
end
stimTable.oddPlace = oddPlace;

return