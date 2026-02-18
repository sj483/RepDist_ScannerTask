function [CountDurs,ScrollStarts] = getCountSpecs()

if exist('CountSpecs.mat','file')
    X = load('CountSpecs.mat');
    CountDurs = X.CountDurs;
    ScrollStarts = X.ScrollStarts;
    return
end

rng(0);
nRuns = 4;
nRepsPerRun = 5;
SlotPerms = getSlotPerms();
countStats = reshape(-SlotPerms(SlotPerms<0),4,4);

% Dimention of stats
d = [nRepsPerRun-1,nRuns];

% Count durations (in seconds)
CountDurs = rand(d).*4 + 4;

% Scroll starts
ScrollStarts = round( countStats -((3/2).*CountDurs) +normrnd(0,3,d) );
return