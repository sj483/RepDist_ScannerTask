function [globals] = showArrow(duration,globals)

% Draw the texture
Screen('DrawTexture', globals.window, globals.arrow, [], ...
    globals.xyEdgesNumAr);

% Flip the screen
Screen('Flip', globals.window, globals.t);

% Update globals.t so the blank screen is shown for the intended duration
waitframes = round(duration / globals.ifi);
globals.t = globals.t + (waitframes * globals.ifi);
return