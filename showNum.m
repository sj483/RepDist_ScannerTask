function [globals] = showNum(countStart, duration, globals)

% Draw the number sprite
textureIdx = globals.textures.numbers(countStart);
Screen('DrawTexture', ...
    globals.window, ...
    textureIdx, ...
    [], ...
    globals.xyEdgesNumMid);

% Flip the screen
Screen('Flip', globals.window, globals.t);

% Update globals.t so the blank screen is shown for the intended duration
waitframes = round(duration / globals.ifi);
globals.t = globals.t + (waitframes * globals.ifi);
return