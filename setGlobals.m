function [globals] = setGlobals(globals)

%% Set the unit length of each IO pulse
globals.portUnitLength = 8/1000;

%% Keyboard settings
KbName('UnifyKeyNames');
globals.escapeKey = KbName('ESCAPE');
globals.upKey = KbName('y');
globals.downKey = KbName('b');
globals.sKey = KbName('s');

%% Set monoschrome values
[globals.white, globals.grey, globals.black] = setMonochromes();

%% Open the PsychToolbox window
[globals.window, globals.windowRect] = PsychImaging(...
    'OpenWindow', 0, globals.grey);

%% Load the stimulus textures
nImgs = 54;
stimTypes = {'Typicals';'Oddballs'};
cats = {'Ani', 'Art', 'Fac', 'Foo', 'Lin','Obj', 'Pla', 'Spa','Tex'};
for iStimType = 1:numel(stimTypes)
    cStimType = stimTypes{iStimType};
    globals.textures.(cStimType) = nan(nImgs,1);
    for ii = 1:nImgs
        catIdx = floor((ii-1)/6);
        subIdx = mod(ii-1,6);
        fn = fullfile(pwd, 'Imgs', cStimType, ...
            sprintf('%s%i.png', cats{catIdx}, subIdx));
        [Img,~,Alpha] = imread(fn);
        Img = cat(3, Img, Alpha);
        globals.textures.(cStimType)(ii) = Screen('MakeTexture', ...
            globals.window, Img);
    end
end

%% Load the number textures
globals.textures.numbers = nan(100,1);
for ii = 1:numel(globals.textures.numbers)
    num = ii - 1;
    fn = fullfile(pwd, 'Imgs', 'CountTask', ...
        sprintf('%03d.png', num));
    Img = imread(fn);
    globals.textures.numbers(ii) = Screen('MakeTexture', ...
        globals.window, Img);
end

%% Load the arrow texture
fn = fullfile(pwd, 'Imgs', 'CountTask', 'Arrow.png');
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

%% extract the permutations for that subject into one long list
imgPerms = load('imgPerms.mat');
imgPerms = imgPerms.perms;
try
    imgPerm = imgPerms.(globals.subjectId);
catch
    error(['The requested subjectId (%s) is not associated with an ',...
        'image permutation in "taskPerms.mat"'],globals.subjectId);
end
globals.imgPerm = imgPerm;

%% Set the inter-frame interval
globals.ifi = Screen('GetFlipInterval', globals.window);

%% Pen width for drawing the frames
globals.penWidthPixels = 6;

%% Get an initial screen flip for timing
globals.t = Screen('Flip', globals.window);

return