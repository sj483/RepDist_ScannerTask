function [r, tR, globals] = getCountResponse(scrollStart, globals)

% Set the time out at 2 seconds
tTimeOut = globals.t + 2;

drawScroll(number, globals);
r = NaN;
tR = NaN;
now = GetSecs();
tLastValidScroll = -Inf;
currentNumber = scrollStart;
while now < tTimeOut
    [keyIds, keyTime] = liKeyWait(allowableKeys, tTimeOut);
    if keyTime > (tLastValidScroll + 0.25)
        if ismember(globals.downKey,keyIds) && currentNumber > 0
            currentNumber = currentNumber - 1;
            drawScroll(currentNumber, globals);
            tLastValidScroll = keyTime;
        elseif ismember(globals.upKey,keyIds) && currentNumber < 99
            currentNumber = currentNumber + 1;
            drawScroll(currentNumber, globals);
            tLastValidScroll = keyTime;
        end
    end

    % Set r and tR
    if isfinite(tLastValidScroll)
        % Buttons have been pressed
        r = currentNumber;
        tR = tLastValidScroll;
    else
        % Buttons have not been pressed
        r = currentNumber*1i;
    end
    
    % Set now
    now = GetSecs();
end

globals.t = tTimeOut;
return

function [tDraw] = drawScroll(number, globals)

    % Draw the smaller number
    Screen('DrawTexture',...
        globals.window,...
        globals.textures.numbers(number-1),...
        [],...
        globals.xyEdgesNumLeft);

    % Draw the central number & frame
    Screen('DrawTexture',...
        globals.window,...
        globals.textures.numbers(number),...
        [],...
        globals.xyEdgesNumMid);
    Screen('FrameRect',...
        globals.window,...
        globals.white,...
        globals.xyEdgesFrameMid,...
        globals.penWidthPixels);

    % Draw the larger number
    Screen('DrawTexture',...
        globals.window,...
        globals.textures.numbers(number+1),...
        [],...
        globals.xyEdgesNumRight);

    % Flip the screen
    tDraw = Screen('Flip', globals.window, globals.t);
    return