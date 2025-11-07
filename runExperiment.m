function [] = runExperiment()

clear all; %#ok<CLALL>
subjectId = getSubjectId();

%image permutations for each participant do not change between runs so are
%set once at the beginning of the experiment 
strct = load("taskPerms.mat");
perms = strct.perms; % unpack variable so not in extra layer of struct
try
    perms = perms.(subjectId); %extract that subject's specific permutations 
catch
    errordlg(sprintf('Task Permutations for this SubjectId\n could not be found'),'File Error');
    error('Task Permutations for this SubjectId\ncould not be found','double');
end 

%divide the set of starting numbers for the counting task into 5 runs 
allStartNums = [61;64;65;67;68;71;74;77;85;88;91;92;94;95;97;98];
sNIdx = Shuffle(1:16);
for irun = 1:4
    Shuffle(sNIdx);
    cidxs = sNIdx(1:4);
    startNums.(['Run',int2str(irun)]) = allStartNums(cidxs);
    sNIdx = sNIdx(~ismember(sNIdx, cidxs));
end 

for iRun = 1:4
    if iRun > 1
        questdlg(...
            sprintf('Continue to run %i?',iRun),...
            'Continue?', ...
            'I am ready','I am ready');
    end
    runRun(subjectId,iRun,perms,startNums);
end

return