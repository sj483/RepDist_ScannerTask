function [] = runExperiment()

clear all; %#ok<CLALL>
subjectIdx = getSubjectIdx();

for iRun = 1:4
    if iRun > 1
        questdlg(...
            sprintf('Continue to run %i?',iRun),...
            'Continue?', ...
            'I am ready','I am ready');
    end
    stoppedEarly = runRun(subjectIdx,iRun);
    if stoppedEarly
        return
    end 
end
return