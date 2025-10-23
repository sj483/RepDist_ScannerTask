function [r,globals] = showScroll(options,globals)

numberLine = 1:100;

allowableKeys = [globals.upKey, globals.downKey];
%numShowing starts on a number U(7,-7) away from the 'reasonable' answer
% and then is updated as they scroll through the options)
numShowing = options.scrlStart;

tStart = drawScroll(numShowing, [1,1,1].*globals.white, globals);

tTimeOut = (tStart + options.dur);
r = NaN;
now = GetSecs();
tLastValidScroll = -Inf;
while now < tTimeOut
    [keyIds, keyTime] = liKeyWait(allowableKeys, tTimeOut);
    globals.t = keyTime;
    if ismember(globals.upKey,keyIds) && numShowing< max(numberLine)
        if keyTime > (tLastValidScroll + 0.25)
            %liSendTrig(0, globals);
            numShowing = numShowing + 1;

            %draw one number higher
            drawScroll(numShowing, [1,1,1].*globals.white, globals);
            tLastValidScroll = keyTime;
        end
    elseif ismember(globals.downKey,keyIds) && numShowing> min(numberLine)
        if keyTime > (tLastValidScroll + 0.25)
            % liSendTrig(1, globals);
            numShowing = numShowing -1;
            %draw one number higher
            drawScroll(numShowing, [1,1,1].*globals.white, globals);
            tLastValidScroll = keyTime;
        end
    end
    if isnan(keyIds)
        %allows us to dinstinguish whether they actually responded

        r = numShowing+ 1i;
    else
        r = numShowing;
    end
    now = GetSecs();
end

globals.t = tTimeOut;
return