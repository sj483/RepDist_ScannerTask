function [globals] = showNum(startNum, duration, globals)

%extract correct texture for relevant number 
texture = globals.numTextures(startNum);


Screen('DrawTexture', globals.window, texture, [], globals.xyEdgesNumAr);

% Flip the screen
Screen('Flip', globals.window, globals.t);

% Update globals.t so the blank screen is shown for the intended duration
waitframes = round(duration / globals.ifi);
globals.t = globals.t + (waitframes * globals.ifi);

%Screen('Close', texture)

return