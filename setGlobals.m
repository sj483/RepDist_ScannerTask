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

%% Open the PsychToolbox window
[globals.window, globals.windowRect] = PsychImaging(...
    'OpenWindow', 0, globals.grey);

%% Load the stimulus textures
for iStim = 1:size(globals.StimTable,1)

    % Typicals
    fn = globals.StimTable.imgPath_Typical{iStim};
    [Img,~,Alpha] = imread(fn);
    Img = cat(3, Img, Alpha);
    globals.StimTable.textureIdx_Typical(iStim) = Screen('MakeTexture', ...
        globals.window, Img);

    % Oddballs
    fn = globals.StimTable.imgPath_Oddball{iStim};
    [Img,~,Alpha] = imread(fn);
    Img = cat(3, Img, Alpha);
    globals.StimTable.textureIdx_Oddball(iStim) = Screen('MakeTexture', ...
        globals.window, Img);
end

%% Load the number textures
globals.textures.numbers = nan(100,1);
for ii = 1:numel(globals.textures.numbers)
    num = ii - 1;
    fn = fullfile('.', 'Imgs', 'CountTask', ...
        sprintf('%03d.png', num));
    Img = imread(fn);
    globals.textures.numbers(ii) = Screen('MakeTexture', ...
        globals.window, Img);
end

%% Load the arrow texture
fn = fullfile('.', 'Imgs', 'CountTask', 'Arrow.png');
Img = imread(fn);
globals.textures.arrow = Screen('MakeTexture', globals.window, Img);

%% Set the xy co-ords
% Get the screen dimensions
[nX, nY] = Screen('WindowSize', globals.window);
globals.dimScrn = [nX, nY];

% Get the centre + edge coordinates for the window
[x,y] = RectCenter(globals.windowRect);
globals.xyCentreScrn = [x;y];
globals.xyEdgesScrn = Screen('Rect', globals.window);

% Get the edge coordinates for the stimuli
stimWidth = 830 -1;
globals.xyEdgesStim = CenterRectOnPoint(...
    [0 0 stimWidth stimWidth],...
    globals.xyCentreScrn(1), globals.xyCentreScrn(2));

% Get the edge coordinates for centrally presented numbers
numWidth = 200 -1;
globals.xyEdgesNumMid = CenterRectOnPoint(...
    [0 0 numWidth numWidth],...
    globals.xyCentreScrn(1), globals.xyCentreScrn(2));

% Get the edge coordinates for a centrally presented number frame
globals.xyEdgesFrameMid = globals.xyEdgesNumMid + [-20,-20,+20,+20];

% Get the edge coordinates for the flanking numbers
numWidth = 150 -1;
globals.xyEdgesNumLeft = CenterRectOnPoint(...
    [0 0 numWidth numWidth],...
    globals.xyCentreScrn(1) - 300, globals.xyCentreScrn(2));
globals.xyEdgesNumRight = CenterRectOnPoint(...
    [0 0 numWidth numWidth],...
    globals.xyCentreScrn(1) + 300, globals.xyCentreScrn(2));

%% Set the inter-frame interval
globals.ifi = Screen('GetFlipInterval', globals.window);

%% Pen width for drawing the frames
globals.penWidthPixels = 6;

%% Get an initial screen flip for timing
globals.t = Screen('Flip', globals.window);
return