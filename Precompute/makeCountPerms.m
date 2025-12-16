% Number of subjects
nSubs = 40; % change as needed
% Generate subject IDs Subject-%02d', SubjectN)
subjectIds = arrayfun(@(x) sprintf('Subject_%02d', x), (1:nSubs)', 'UniformOutput', false);

for iSubject = 1:numel(subjectIds)
    cId = subjectIds{iSubject};
    randomSeed = str2double(cId(end-1:end));
    rng(randomSeed,"twister");
    %divide the set of starting numbers for the counting task into 5 runs
    allStartNums = [61;64;65;67;68;71;74;77;85;88;91;92;94;95;97;98];
    sNIdx = Shuffle(1:16);
    for irun = 1:4
        Shuffle(sNIdx);
        cidxs = sNIdx(1:4);
        startNums.(['Run',int2str(irun)]) = allStartNums(cidxs);
        sNIdx = sNIdx(~ismember(sNIdx, cidxs));
    end
countPerms.(cId) = startNums;
end