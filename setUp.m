function [globals] = setUp(globals)

%% Set skip preference
% Last argument is as follows:
% ... 0: Don't skip the sync-test
% ... 2: Skip the sync-test
Screen('Preference','SkipSyncTests', globals.skip);

%% Do basic setup including norming chanel values
% this should happen before setMonochromes to be safe
PsychDefaultSetup(2);

if globals.skip ==2
    windowPntr = 2;
else
    windowPntr = 1;
end 

%% Set monoschrome values
[globals.white, globals.black, globals.grey] = setMonochromes();

%% Open the PsychToolbox window
[globals.window, globals.windowRect] = PsychImaging('OpenWindow', windowPntr, globals.grey); 

% Retreive the maximum priority number and set the execution priority of your script
topPriorityLevel = MaxPriority(globals.window);
Priority(topPriorityLevel);

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', globals.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

return