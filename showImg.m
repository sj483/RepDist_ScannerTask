function [r,globals] = showImg(trial,duration,globals)

%%select texture for that trial
texture = globals.imgTextures{trial};

% Draw the texture
Screen('DrawTexture', ...
    globals.window, ...
    texture, ...
    [], ...
    globals.xyEdgesCues, 0);

% Flip the screen
Screen('Flip', globals.window, globals.t);

% for recieving response from button box
%% Request response
[r, globals] = requestResponse(duration, globals);

% Update globals.t so the texture is shown for the intended duration
waitframes = round(duration / globals.ifi);
globals.t = globals.t + (waitframes * globals.ifi);
Screen('Close', texture) % close the texture so it doesnt ' hang around' as PTB warns
return