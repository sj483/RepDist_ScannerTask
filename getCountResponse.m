function [r, tR, globals] = getCountResponse(scrollStart, globals)

% Set the time out at 2 seconds
tTimeOut = globals.t + 2;

drawScroll(scrollStart, globals);
r = NaN;
tR = NaN;
now = GetSecs();
tLastValidScroll = -Inf;
currentNumber = scrollStart;
while now < tTimeOut
    [keyIds, keyTime] = liKeyWait(...
        [globals.downKey,globals.upKey], tTimeOut);
    if keyTime > (tLastValidScroll + 0.25)
        if ismember(globals.downKey,keyIds) && currentNumber > 1
            currentNumber = currentNumber - 1;
            drawScroll(currentNumber, globals);
            tLastValidScroll = keyTime;
        elseif ismember(globals.upKey,keyIds) && currentNumber < 98
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
    % Add one to the number-1 when indexing (number: 0 -> index: 1).
    Screen('DrawTexture',...
        globals.window,...
        globals.textures.numbers(number),...
        [],...
        globals.xyEdgesNumLeft);

    % Draw the central number & frame
    % Add one to the number when indexing (number: 0 -> index: 1).
    Screen('DrawTexture',...
        globals.window,...
        globals.textures.numbers(number+1),...
        [],...
        globals.xyEdgesNumMid);
    Screen('FrameRect',...
        globals.window,...
        globals.white,...
        globals.xyEdgesFrameMid,...
        globals.penWidthPixels);

    % Draw the larger number
    % Add one to the number+1 when indexing (number: 0 -> index: 1).
    Screen('DrawTexture',...
        globals.window,...
        globals.textures.numbers(number+2),...
        [],...
        globals.xyEdgesNumRight);

    % Flip the screen
    tDraw = Screen('Flip', globals.window, globals.t);
    return