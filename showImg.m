function [r,globals] = showImg(imgTexture,duration,globals)

% Draw the texture
Screen('DrawTexture', ...
    globals.window, ...
    imgTexture, ...
    [], ...
    globals.xyEdgesCues, 0);

% Flip the screen
Screen('Flip', globals.window, globals.t);

% receive response from button box (for Oddball task)
%% Request response
[r, globals] = requestResponse(duration, globals);

% Update globals.t so the texture is shown for the intended duration
waitframes = round(duration / globals.ifi);
globals.t = globals.t + (waitframes * globals.ifi);
return