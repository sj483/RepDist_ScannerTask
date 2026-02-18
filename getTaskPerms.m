function [ImgPerms,SlotPerms] = getTaskPerms()

if exist('TaskPerms.mat','file')
    X = load('TaskPerms.mat');
    ImgPerms = X.ImgPerms;
    SlotPerms = X.SlotPerms;
    return
end

rng(1729);
nImgs = 54;
nSubjects = 40;
nRuns = 4;
nRepsPerRun = 5;
nNullsPerRep = 3;
countStats = [
    86	62	91	76  Inf
    71	82	66	95	Inf
    93	64	85	78	Inf
    96	61	89	79	Inf];

% Image permulations (1-ordered, unique for each subject)
ImgPerms = nan(nImgs,nSubjects);
for iSubject = 1:nSubjects
    P = cellfun(@(iC) iC + (randperm(6)'),...
        num2cell(6*(randperm(9)-1)),'UniformOutput',false);
    ImgPerms(:,iSubject) = reshape(cell2mat(P),nImgs,1);
end

% Slot permulations (1-ordered + NaNs, common across all subjects)
dTrialPerms = [(nImgs+nNullsPerRep)*nRepsPerRun+(nRepsPerRun-1),nRuns];
SlotPerms = nan(dTrialPerms);
for iRun = 1:nRuns
    P = repmat([nan(nNullsPerRep,1);(1:nImgs)'],1,nRepsPerRun);
    P = mat2cell(P,nImgs+nNullsPerRep,ones(1,nRepsPerRun));
    P = cellfun(@(v)v(randperm(numel(v))),P, ...
        'UniformOutput',false);
    P = cell2mat(P);
    P = [P;-countStats(iRun,:)]; % Add counting task
    P = P(:);
    P = P(1:end-1); % Remove final counting task
    SlotPerms(:,iRun) = P;
    clear P;
end

return