function [r,keyTime,globals] = showImg(imgTexture,duration,globals)

% Draw the texture
Screen('DrawTexture', ...
    globals.window, ...
    imgTexture, ...
    [], ...
    globals.xyEdgesStim, 0);

% Flip the screen
Screen('Flip', globals.window, globals.t);

% Wait for a response
[keyIds,keyTime] = liKeyWait(...
    [globals.downKey;globals.upKey], globals.t + duration);
r = any(~isnan(keyIds));

% Update globals.t so the texture is shown for the intended duration
waitframes = round(duration / globals.ifi);
globals.t = globals.t + (waitframes * globals.ifi);
return