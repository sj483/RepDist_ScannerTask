rng(1729);

nImgs = 54;
nSubjects = 40;
nRuns = 4;
nRepsPerRun = 5;
nNullsPerRep = 3;
countStats = [
    86	62	91	76	67
    71	82	66	95	69
    93	64	85	78	72
    96	61	89	79	68];

% Image permulations (1-ordered, unique for each subject)
ImgPerms = nan(nImgs,nSubjects);
for iSubject = 1:nSubjects
    P = cellfun(@(iC) iC + (randperm(6)'),...
        num2cell(6*(randperm(9)-1)),'UniformOutput',false);
    ImgPerms(:,iSubject) = reshape(cell2mat(P),nImgs,1);
end

% Trial permulations (1-ordered + NaNs, common across all subjects)
dTriPerm = [(nImgs+nNullsPerRep)*nRepsPerRun+(nRepsPerRun-1),nRuns];
TriPerm = nan(dTriPerm);
for iRun = 1:nRuns
    P = repmat([nan(nNullsPerRep,1);(1:nImgs)'],1,nRepsPerRun);
    P = mat2cell(P,nImgs+nNullsPerRep,ones(1,nRepsPerRun));
    P = cellfun(@(v)v(randperm(numel(v))),P, ...
        'UniformOutput',false);
    P = cell2mat(P);
    P = [P;-countStats(iRun,:)]; % Add counting task
    P = P(:);
    P = P(1:end-1); % Remove final counting task
    TriPerm(:,iRun) = P;
    clear P;
end