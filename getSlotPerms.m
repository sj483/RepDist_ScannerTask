function [SlotPerms] = getSlotPerms()

if exist('SlotPerms.mat','file')
    X = load('SlotPerms.mat');
    SlotPerms = X.SlotPerms;
    return
end

rng(1729);
nImgs = 54;
nRuns = 4;
nRepsPerRun = 5;
nNullsPerRep = 3;
countStats = [
    86	62	91	76  Inf
    71	82	66	95	Inf
    93	64	85	78	Inf
    96	61	89	79	Inf];

% Slot permulations (1-ordered + NaNs, common across all subjects)
dTrialPerms = [(nImgs+nNullsPerRep)*nRepsPerRun+(nRepsPerRun-1),nRuns];
SlotPerms = nan(dTrialPerms);
for iRun = 1:nRuns
    P = repmat([nan(nNullsPerRep,1);(1:nImgs)'],1,nRepsPerRun);
    P = mat2cell(P,nImgs+nNullsPerRep,ones(1,nRepsPerRun));
    P = cellfun(@(v)v(randperm(numel(v))),P, ...
        'UniformOutput',false);
    P = cell2mat(P);
    P = [P;-countStats(iRun,:)]; %#ok<AGROW> % Add counting task
    P = P(:);
    P = P(1:end-1); % Remove final counting task
    SlotPerms(:,iRun) = P;
    clear P;
end

return