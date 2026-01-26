function [] = makeTaskIO(globals)

TaskIO = struct;

runIdx = globals.runIdx;
TriPerm = globals.TriPerm; % Constant over subjects  (OR LOAD IN)
stimTable = globals.stimTable; % Variable over subjects

trialPerm = TriPerm(:,runIdx);
TaskIO.trialType = cell(size(trialPerm));
for ii = 1:numel(trialPerm)
    if isnan(trialPerm(ii))
        TaskIO.trialType{ii} = 'Null';
    elseif trialPerm(ii) < 0
        TaskIO.trialType{ii} = 'CountDown';
    else
    end
end

return