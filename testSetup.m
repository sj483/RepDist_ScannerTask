function [] = testSetup() 

% Clear the screen
sca;
close all;

%% Create the globals structure
runIdx = 1;
subjectIdx = 40;

%% Set the globals
globals = setGlobals(subjectIdx,runIdx);

%% Set-up PsychToolbox
globals = setUp(globals);
penWidthPixels = 6;
allowableKeys = [globals.downKey, globals.upKey];

%% Draw the rect to the screen
Screen('FrameRect', globals.window, [0,0,1].*globals.white, globals.xyEdgesScrn, penWidthPixels)
Screen('FrameRect', globals.window, [0,0,1].*globals.white, globals.xyEdgesStim, penWidthPixels)
Screen('FrameRect', globals.window, [0,0,1].*globals.white, globals.xyEdgesFrameMid, penWidthPixels)
Screen('FrameRect', globals.window, [0,1,0].*globals.white, globals.xyEdgesNumRight, penWidthPixels)
Screen('FrameRect', globals.window, [1,0,0].*globals.white, globals.xyEdgesNumLeft, penWidthPixels)

%% Flip to the screen
Screen('Flip', globals.window);

kbIds = liKeyWait(allowableKeys,Inf);
keyNames = KbName(kbIds);
disp(keyNames);
disp(kbIds);
KbStrokeWait;

%% Clear the screen
sca;

return