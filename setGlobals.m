function [globals] = setGlobals(globals, runOrderStrt)

% Set the unit length of each IO pulse
globals.portUnitLength = 8/1000;

% Keyboard settings
KbName('UnifyKeyNames');
globals.escapeKey = KbName('ESCAPE');
globals.scrollKey = KbName('b');
globals.acceptKey = KbName('y');
globals.sKey = KbName('s');

%% Set monoschrome values
[globals.white, globals.black] = setMonochromes();

%% Open the PsychToolbox window
[globals.window, windowRect] = PsychImaging('OpenWindow', 0, globals.black); % !have changed the screen to use but change this back in future!


%% Set the xy co-ords
% Get the size of the on screen window
[nX, nY] = Screen('WindowSize', globals.window);

% Get the centre coordinates of the window
[cx,cy] = RectCenter(windowRect);
globals.xyCentreScrn = [cx;cy];
globals.xyEdgesScrn = Screen('Rect', globals.window);

% 'Cues' i.e. the images from the different categories
cueImgWidth = 830;
globals.xyEdgesCues = CenterRectOnPoint(...
    [0 0 cueImgWidth cueImgWidth],...
    globals.xyCentreScrn(1), globals.xyCentreScrn(2));

% 'numAr' i.e. the numbers and the down arrow
numArImgWidth = 100;
globals.xyEdgesNumAr = CenterRectOnPoint(...
    [0 0 numArImgWidth numArImgWidth],...
    globals.xyCentreScrn(1), globals.xyCentreScrn(2));

% Resp
[globals.xyEdgesResp, globals.xyCentreResp] = setRespCoords(nX, nY,cy);

%% Set the fixation cross
%globals.cross = setCross();


%% Making the stimuli imgs into textures 
    %read in img files into an array in the run order (dictated by opseq)
    globals.imgTextures = cell(numel(runOrderStrt),1); 
    for ii = 1:numel(runOrderStrt)
        imgFile = imread(runOrderStrt(ii).fPath);
        globals.imgTextures{ii} = Screen('MakeTexture', globals.window, imgFile);
    end 

%% MAKE NUMBER TEXTURES - refactor this too ?
nOfNum = 17; % this is the number of options of counting start numbers 
cRange = 1:17; % the actual selection of number textures we'll need is from 2-17 but the 1 is made just to make indexing the rest more logical
globals.numTextures = nan(nOfNum,1); 

for ii = cRange
    nText = num2str(ii);
    globals.numTextures(ii) = makeText(nText,globals);   
end

aText = "arrow";
globals.arrow = makeText(aText, globals);


%% Miscellaneous setting

% Set the inter-frame interval
globals.ifi = Screen('GetFlipInterval', globals.window);

% Pen width for drawing the frames
globals.penWidthPixels = 6;

% Get an initial screen flip for timing
globals.t = Screen('Flip', globals.window);

return