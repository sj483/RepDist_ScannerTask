function [subjectId] = getSubjectId()

% Get Subject number
userInput = inputdlg({'Enter SubjectId (string):'},'SubjectId',1);
subjectId = str2double(userInput{1});
%format the raw number from user (can have leading zeros or not)
subjectId = sprintf('Subject_%02d',subjectId);

% Confirm details
ConfStr = sprintf(...
    'Experiment ready to begin...%cSubjectId: %s%cIs this detail correct and do you wish to continue?',...
    10,subjectId,10);
ConfirmDlg = questdlg(ConfStr,'Confirm details','YES','NO','NO');
if ~strcmp(ConfirmDlg,'YES')
    error('Script terminated by user!');
end

return