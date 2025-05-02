function [globals] = setGlobals(globals,perms)

% Set the unit length of each IO pulse
globals.portUnitLength = 8/1000;

% Keyboard settings
KbName('UnifyKeyNames');
globals.escapeKey = KbName('ESCAPE');
globals.upKey = KbName('b');
globals.downKey = KbName('y');
globals.sKey = KbName('s');

%% Set monoschrome values
[globals.white, globals.black] = setMonochromes();

%% Open the PsychToolbox window
[globals.window, windowRect] = PsychImaging('OpenWindow', 2, globals.black); % !have changed the screen to use but change this back in future!


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

% 'numAr' is used by both the central number in the counting task and the down arrow
numArImgWidth = nX/5;
globals.xyEdgesNumAr = (CenterRectOnPoint(...
    [0 0 numArImgWidth numArImgWidth],...
    globals.xyCentreScrn(1), globals.xyCentreScrn(2)))';

% this sets to location of flanking numbers on the scroll page
[globals.xyEdgesResp, globals.xyCentreResp] = setRespCoords(nX, nY,cy);

%% Set the fixation cross
%globals.cross = setCross();


%extract the permutations for that subject into one long list
globals.imgPerms = nan(54,1);
for cc = 1:9
    cat = perms.catPerm(cc);
    for ii = 1:6
        imgN = perms.imgPerm{cc}(ii);
        globals.imgPerms(ii+(cc-1)*6,1) = imgN + (cat-1)*6 ;
    end
end

%% Making the stimuli imgs into textures
categories = ["Ani", "Art", "Fac", "Foo", "Ifa", "Lin","Obj", "Pla", "Spa"];
globals.imgTextures = nan(54,1);
for tt = 1:54
    catIdx = ceil(tt/6);
    codeId = tt - (catIdx-1)*6 -1;  %images are zero ordered
    fPath = fullfile(cd, 'Imgs', ...
        sprintf('%s%i%s', categories(catIdx), codeId, '.png'));
    imgFile = imread(fPath);
    globals.imgTextures(tt,1) = Screen('MakeTexture', globals.window, imgFile);
end

%% MAKE NUMBER TEXTURES 
nOfNums = 100; 
globals.numTextures = nan(nOfNums,1); 

% number textures are positioned in an array so that 
% their index = their numerical value
for nn = 1:nOfNums
    globals.numTextures(nn) = makeText(nn,globals);   
end

aText = 'arrow';
globals.arrow = makeText(aText, globals);


%% Miscellaneous setting

% Set the inter-frame interval
globals.ifi = Screen('GetFlipInterval', globals.window);

% Pen width for drawing the frames
globals.penWidthPixels = 6;

% Get an initial screen flip for timing
globals.t = Screen('Flip', globals.window);
globals.respT = NaN;

return