function [taskIO] = setTaskIO2(SubjectId,RunId, runOrderStrt, globals)

randomSeed = hex2dec(SubjectId) + RunId*100;
rng(randomSeed,"twister"); %I dont think i acc need to save the seed because we can just record the durations for the counting task

%% Preallocate the TaskIO structure
numTrials = 54 + 1; % num images + num counting task(present + respond) 
taskIO = repmat((struct(... %Image_Id, Category, Dur, Response, tResponse 
    'Category', [], ...
    'imageId', NaN, ...
    'isiLength', NaN, ...
    'arrayPerm', [], ...
    'tShow', NaN,...
    'correctResp', NaN,...
    'opt1', NaN,...
    'opt2', NaN,...
    'Response', NaN, .... % this is new (is for the dots and counting task
    'textureNum', [])), ...% you'll need this for the Counting task
    numTrials,1);

%%
for iTrial = 1:numTrials
       
    if iTrial == 55
       %Counting trial
        taskIO(iTrial).Category = "count";
        % so the whole 'trial' needs to be 15 seconds long everytime so the 
        % counting task itself can only be max 8 seconds long to give a
        % minimum of 6 seconds to answer, so counting periods will be 4-8
        % seconds
        countRange = 4:8; 
        s1idx = randi([1,4]);
        durArrow = countRange(s1idx);  
        startRange = 10:17; %the selection of numbers to start counting from
        s2idx = randi([1,8]);
        startNum = startRange(s2idx); 
        % assigning the number from which to start counting back
        taskIO(iTrial).imageId = startNum*1i ;  %this is to differentiate from the stimulus ids 
        % assigning the time for which the arrow will be shown after the 
        % number is displayed in the count task
        taskIO(iTrial).isiLength = durArrow;
        taskIO(iTrial).startPos = randi(3);
        % below is the number the participant should have got to if they 
        % counted down from the start num for the duration of the arrow
        taskIO(iTrial).correctResp = startNum - durArrow; 
        %the minimum value of the real answer is 2 (10-8) and the max value 
        % for the potential answers should be atleast 1 less than the start number
        %otherwise options could be obviously wrong
        pAnswers = 2:(startNum-1);
        %remove correct answer from selection - the real answer will be in
        %the range of 2:13, and the maximum range of pAnswers is 2:16 so
        %the real answer is garunteed to be found in pAnswers
        pAnswers = pAnswers(pAnswers~=taskIO(iTrial).correctResp);
        pAnswers = Shuffle(pAnswers);
        %assign other 2 options
        taskIO(iTrial).opt1 = pAnswers(1);
        taskIO(iTrial).opt2 = pAnswers(2);

    else 
        %fill in options for normal picture trials
        taskIO(iTrial).Category = runOrderStrt(iTrial).Category;
        taskIO(iTrial).imageId = runOrderStrt(iTrial).imageId;
        taskIO(iTrial).isiLength = 0.5;
        taskIO(iTrial).textureNum = globals.imgTextures{iTrial};
    end
 end

return