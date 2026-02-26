function [globals] = setGlobals(subjectIdx,runIdx)

%% Set the sujectIdx and the runIdx
globals = struct;
globals.subjectIdx = subjectIdx; % 1-ordered
globals.runIdx = runIdx; % 1-ordered

%% Set stoppedEarly
globals.stoppedEarly = false;

%% Set the OddBallDist
globals.OddballDist = getOddballDist();

%% Set the Countdown specs
[CountDurs,ScrollStarts] = getCountSpecs();
globals.countDur = CountDurs(:,runIdx);
globals.scrollStart = ScrollStarts(:,runIdx);

%% Set the StimTable
ImgPerms = getImgPerms();
imgPerm = ImgPerms(:,subjectIdx);
globals.StimTable = getStimTable(imgPerm);

%% Set the unit length of each IO pulse
globals.portUnitLength = 8/1000;

%% Keyboard settings
KbName('UnifyKeyNames');
globals.escapeKey = KbName('ESCAPE');
globals.downKey = KbName('b');
globals.upKey = KbName('y');
globals.sKey = KbName('s');

%% Set monoschrome values
[globals.white, globals.grey, globals.black] = setMonochromes();

%% Pen drawing options
globals.penWidthPixels = 6;
globals.stimWidth = 830 -1;
globals.numMidWidth = 200 -1;
globals.frameMarginNumMid = [-20,-20,+20,+20];
globals.numFlankWidth = 150 -1;
globals.numFlankOffset = 300;
return