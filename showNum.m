function [globals] = showNum(countStart, duration, globals)

% Draw the number sprite
% Add one to the countStart when indexing (number: 0 -> index: 1).
textureIdx = globals.textures.numbers(countStart+1);
Screen('DrawTexture', ...
    globals.window, ...
    textureIdx, ...
    [], ...
    globals.xyEdgesNumMid);

% Flip the screen
Screen('Flip', globals.window, globals.t);

% Send the trigger 
liSendTrig(2,globals);

% Update globals.t so the blank screen is shown for the intended duration
waitframes = round(duration / globals.ifi);
globals.t = globals.t + (waitframes * globals.ifi);
return