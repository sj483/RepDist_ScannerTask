function [globals] = showArrow(dur,globals)

texture = globals.arrow;

Screen('DrawTexture', globals.window, texture, [], globals.xyEdgesNumAr);

% Flip the screen
Screen('Flip', globals.window, globals.t);

% Update globals.t so the blank screen is shown for the intended duration
waitframes = round(dur / globals.ifi);
globals.t = globals.t + (waitframes * globals.ifi);
return

