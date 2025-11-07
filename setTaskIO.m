function [taskIO] = setTaskIO(runOrder, globals, startNums)
%imgs ids refers to the following:
% Ani = [1:6];
% Art = [7:12];
% Fac = [13:18];
% Foo = [19:24];  
% Lin = [25:32];
% Obj = [33:38];
% Pla = [39:42];
% Spa = [43:48];
% Tex = [49:54];
%countTrialId = 55;

%imgCode refers to the id within the category e.g. sea slug is 5 of 'Ani'

%take the number element of the subjectId as the seed
randomSeed = str2double(globals.subjectId(end-1:end)) + globals.runId*100;
rng(randomSeed,"twister"); 
%only thing this would be neccersary for is 
% reconstituting the exact timings on the counting task


%convert the runOrder from base ids into the 'meaningful' image ids using
%that subject's specific permutations 
permdRunOrder = getPmdRunOrd(runOrder,globals);
%add in counting trials which I have coded as 55
permdRunOrder = insertCountTrials(permdRunOrder);

%load in the oddBall permutation:
strct = load("obPerm.mat");
obPerm = strct.M;
%last current row needed (e.g. row 10 for run 2)
lcRow = globals.runId*5; 
%all rows needed from obPerm, for this run (current)
cRows = (lcRow-4):lcRow; % (nReps = 4)
obPerm = obPerm(cRows,:);

%the category labels below align with the naming of the image files - will
%break if they are changed!!
% categories = ["Ani", "Art", "Fac", "Foo", "Lin","Obj", "Pla", "Spa", "Tex"];
categories = {"Ani"; "Art"; "Fac"; "Foo"; "Lin";"Obj"; "Pla"; "Spa"; "Tex"};

%% Preallocate the TaskIO structure
nReps = 5;
numTrials = (54*nReps) + (nReps-1); % num images + num counting task(present + respond)

taskIO = repmat((struct(...
    'type', [], ...
    'imageCode', NaN, ...
    'isiLength', NaN, ...
    'tShow', NaN,...
    'startNum', NaN,...
    'scrlStart', NaN,...
    'correctResp', NaN,... %THIS WILL BE FOR ODDBALL TRIALS
    'response', NaN, .... % this is for both oddball & counting
    'textureId', [], ...
    'trigId',[])), ...
    numTrials,1);

%%
repCounter = 1;
for iTrial = 1:numTrials
       
    if permdRunOrder(iTrial) == 55
       %Counting trial
        taskIO(iTrial).type = 'countingTrial';
        %CALCULATE TRIAL PARAMS   
        startNum = startNums(repCounter);
        durArrow = (rand(1)*4)+4; %uniform distribution of 4-8 seconds
        scrlStart = round(startNum - (3/2 * durArrow) + normrnd(0,3)); %where the answer scroller starts at
        %ASSIGN TRIAL PARAMS
        % assigning the number from which to start counting back
        taskIO(iTrial).startNum = startNum;
        % assigning the time for which the arrow will be shown after the 
        % number is displayed in the count task
        taskIO(iTrial).isiLength = durArrow;
        taskIO(iTrial).scrlStart = scrlStart;

        %increment repition number before the start of the next repeat
        repCounter = repCounter+1;
    elseif isnan(permdRunOrder(iTrial))
        taskIO(iTrial).type = 'null';
        taskIO(iTrial).isiLength = 2.5;
    else 
        %fill in options for normal picture trials
        %CALCULATE TRIAL PARAMS
        imgId = permdRunOrder(iTrial);
        catIdx = int32(ceil(imgId/6));
        codeId = int32(imgId - (catIdx-1)*6 - 1);
        % disp(iTrial)
        % disp(categories) % debugging
        % disp(catIdx)  % debugging
        % whos catIdx  % debugging
        name = sprintf('%s%i', categories{catIdx,1}, codeId);
        %ASSIGN TRIAL PARAMS
        taskIO(iTrial).imageCode = name;
        %check OB status
        isTarget = obPerm(repCounter,imgId); %is a 1 for OB or 0 for not
        taskIO(iTrial).trigId = getTrigId(imgId,isTarget);
        if isTarget
            taskIO(iTrial).type = 'oddBall';
            taskIO(iTrial).textureId = globals.obTextures(imgId);
            % 64 is the 7th binary column
        else
            taskIO(iTrial).type = 'stim';
            taskIO(iTrial).textureId = globals.imgTextures(imgId);
            taskIO(iTrial).trigId = imgId-1; %this is zero-ordered
        end
        
        taskIO(iTrial).isiLength = 0.5;
    end
 end

return