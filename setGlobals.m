function [globals] = setGlobals(globals,perms)

% Set the unit length of each IO pulse
globals.portUnitLength = 8/1000;

% Keyboard settings
KbName('UnifyKeyNames');
globals.escapeKey = KbName('ESCAPE');
globals.upKey = KbName('y');
globals.downKey = KbName('b');
globals.sKey = KbName('s');

%This changes priority level of script, sets sync test setting and enables alpha blending for transparency
globals = setUp(globals);

%% Set the xy co-ords
% Get the size of the on screen window
[nX, nY] = Screen('WindowSize', globals.window);

% Get the centre coordinates of the window
[cx,cy] = RectCenter(globals.windowRect);
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
    catg = perms.catPerm(cc);
    for ii = 1:6
        imgN = perms.imgPerm{cc}(ii);
        globals.imgPerms(ii+(cc-1)*6,1) = imgN + (catg-1)*6 ;
    end
end


%% Making the stimuli imgs into textures
categories = ["Ani", "Art", "Fac", "Foo", "Lin","Obj", "Pla", "Spa","Tex"];
globals.imgTextures = nan(54,1);
for tt = 1:54
    catIdx = ceil(tt/6);
    codeId = tt - (catIdx-1)*6 -1;  %images are zero ordered
    %normal image version and then oddBall
    version = ["Imgs","Oddballs"];
    field = ["imgTextures", "obTextures"];
    for vv = 1:2
    fPath = fullfile(pwd, version(vv), ...
        sprintf('%s%i%s', categories(catIdx), codeId, '.png'));
    [imgFile,~,alpha] = imread(fPath);
    imgFile = cat(3, imgFile, alpha);
    globals.(field(vv))(tt,1) = Screen('MakeTexture', globals.window, imgFile);
    end
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