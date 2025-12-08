function [tDraw] = drawScroll(numShowing,cursorColour,globals)

midlTxtr = globals.numTextures(numShowing);
lowrTxtr = globals.numTextures(numShowing-1);
upprTxtr = globals.numTextures(numShowing+1);

textures = [lowrTxtr;midlTxtr;upprTxtr];

flankColour = [0.3,0.3,0.3].*globals.white;
frameColours = [flankColour;cursorColour;flankColour];
txtrCoords = {globals.xyEdgesResp(:,1); globals.xyEdgesNumAr;...
    globals.xyEdgesResp(:,3)};

frmCoords = {globals.xyEdgesFrm(:,1); globals.xyEdgesNAfrm;...
    globals.xyEdgesFrm(:,3)};

for iTexture= 1:3
    % Draw textures to backbuffer
    Screen('DrawTexture',...
    globals.window,...
    textures(iTexture),...
    [],...
    txtrCoords{iTexture,1}); 
    % Draw the frames to back buffer
    Screen('FrameRect',...
    globals.window,...
    frameColours(iTexture),...
    frmCoords{iTexture,1},...
    globals.penWidthPixels)
end


% Flip the screen
tDraw = Screen('Flip', globals.window, globals.t);

return