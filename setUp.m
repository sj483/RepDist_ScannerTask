function [globals] = setUp(globals)

%% Open the PsychToolbox window
[globals.window, globals.windowRect] = PsychImaging(...
    'OpenWindow', 0, globals.grey);

%% Default setup
PsychDefaultSetup(2);

%% Retrieve the maximum priority number and set the execution priority
topPriorityLevel = MaxPriority(globals.window);
Priority(topPriorityLevel);

%% Last argument below:
% ... 0: Don't skip the sync-test
% ... 2: Skip the sync-test
Screen('Preference','SkipSyncTests', 0);

%% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', globals.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

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
globals.xyEdgesStim = CenterRectOnPoint(...
    [0, 0, globals.stimWidth, globals.stimWidth],...
    globals.xyCentreScrn(1), globals.xyCentreScrn(2));

% Get the edge coordinates for centrally presented numbers
globals.xyEdgesNumMid = CenterRectOnPoint(...
    [0, 0, globals.numMidWidth, globals.numMidWidth],...
    globals.xyCentreScrn(1), globals.xyCentreScrn(2));

% Get the edge coordinates for a centrally presented number frame
globals.xyEdgesFrameMid = globals.xyEdgesNumMid + ...
    globals.frameMarginNumMid;

% Get the edge coordinates for the flanking numbers
globals.xyEdgesNumLeft = CenterRectOnPoint(...
    [0, 0, globals.numFlankWidth, globals.numFlankWidth],...
    globals.xyCentreScrn(1) - globals.numFlankOffset, ...
    globals.xyCentreScrn(2));
globals.xyEdgesNumRight = CenterRectOnPoint(...
    [0, 0, globals.numFlankWidth, globals.numFlankWidth],...
    globals.xyCentreScrn(1) + globals.numFlankOffset, ...
    globals.xyCentreScrn(2));

%% Hide cursor from screen
HideCursor(globals.window);  

%% Set the inter-frame interval
globals.ifi = Screen('GetFlipInterval', globals.window);

%% Get an initial screen flip for timing
globals.t = Screen('Flip', globals.window);
return