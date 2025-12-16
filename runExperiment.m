function [] = runExperiment()

clear all; %#ok<CLALL>
subjectId = getSubjectId();

answer = questdlg(...
            sprintf('Would you like to skip the sync test?'),...
            'Sync test', 'No', 'Yes I am testing','Yes I am testing');
switch answer
    case 'Yes I am testing'
        skip = 2;
    case 'No'
        skip=0;
    otherwise 
        error('Please choose a valid option')
end

for iRun = 1:4
    if iRun > 1
        questdlg(...
            sprintf('Continue to run %i?',iRun),...
            'Continue?', ...
            'I am ready','I am ready');
    end
    cancel = runRun(subjectId,iRun,skip);
    if cancel
    %This is so user doesn't get stuck in a loop if once of the
    %dialog boxes inside gets closed/cancelled
        error('User terminated script!')
        return 
    end 
end

return