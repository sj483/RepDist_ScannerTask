function [TaskIO] = makeTaskIO(globals)

% Set: nImgs, nNullsPerRep
nImgs = 54;
nNullsPerRep = 3;

% Extract: subjectIdx
subjectIdx = globals.subjectIdx;

% Extract: runIdx
runIdx = globals.runIdx;

% Extract: StimTable
StimTable = globals.StimTable; % Variable over subjects

% Set the slotPerm for this run
SlotPerms = getSlotPerms();
slotPerm = SlotPerms(:,runIdx);
clear('SlotPerms');

% Preallocate the variables:
nSlots = numel(slotPerm);
TaskIO = struct;
TaskIO.subjectIdx = ones(nSlots,1).*subjectIdx;
TaskIO.runIdx = ones(nSlots,1).*runIdx;
TaskIO.trialType = cell(nSlots,1);
TaskIO.repIdx = nan(nSlots,1); % Counts the Reps, 1-ordered 
TaskIO.slotId = slotPerm;
TaskIO.trigId = nan(nSlots,1);
TaskIO.stimulus = cell(nSlots,1);
TaskIO.catId = nan(nSlots,1); % 0-ordered
TaskIO.imgId = nan(nSlots,1); % 0-ordered
TaskIO.response = nan(nSlots,1);
TaskIO.tShow = nan(nSlots,1);
TaskIO.tResponse = nan(nSlots,1);

for iSlot = 1:nSlots
    iRep = floor( (iSlot-1) ./ (nImgs+nNullsPerRep+1) )+1;
    slotId = slotPerm(iSlot);
    TaskIO.slotId(iSlot) = slotId;
    if isnan(slotPerm(iSlot))
        TaskIO.trialType{iSlot} = 'Null';
    elseif slotPerm(iSlot) < 0
        TaskIO.trialType{iSlot} = 'CountDown';
        TaskIO.repIdx(iSlot) = iRep;
        TaskIO.trigId(iSlot) = bin2dec('11100000') + ...
            (runIdx-1)*4 + (iRep-1);
        TaskIO.stimulus{iSlot} = struct(...
            'countStart',-slotId,...
            'countDur',globals.countDur(iRep),...
            'scrollStart',globals.scrollStart(iRep));
    else
        iOddCol = (runIdx-1)*5 + iRep;
        isOdd = globals.OddballDist(slotId,iOddCol);
        TaskIO.repIdx(iSlot) = iRep;
        TaskIO.catId(iSlot) = StimTable.catId(slotId);
        TaskIO.imgId(iSlot) = StimTable.imgId(slotId);
        if ~isOdd
            TaskIO.trialType{iSlot} = 'Typical';
            TaskIO.trigId(iSlot) = StimTable.trigId_Typical(slotId);
            TaskIO.stimulus{iSlot} = StimTable.imgPath_Typical(slotId);
        else
            TaskIO.trialType{iSlot} = 'Oddball';
            TaskIO.trigId(iSlot) = StimTable.trigId_Oddball(slotId);
            TaskIO.stimulus{iSlot} = StimTable.imgPath_Oddball(slotId);
        end
    end
end

TaskIO = struct2table(TaskIO);
return