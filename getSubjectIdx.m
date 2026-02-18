function [subjectIdx] = getSubjectIdx()

% Get SubjectIdx
userInput = inputdlg({'Enter subjectIdx (num):'},'SubjectIdx',1);
if isempty(userInput)
     error('No subjectIdx provided.');
end 

subjectIdx = str2double(userInput{1});

% Confirm details
ConfStr = sprintf(...
    ['Experiment ready to begin...%c',...
    'subjectIdx: %02d%c',...
    'Is this detail correct and do you wish to continue?'],...
    10,subjectIdx,10);
ConfirmDlg = questdlg(ConfStr,'Confirm details','YES','NO','NO');
if ~strcmp(ConfirmDlg,'YES')
    error('Script terminated by user!');
end

return