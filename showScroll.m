function [r,globals] = showScroll(options,globals)

%impossible options are 2/3s of number line so
%smallest startnum that makes sense is 7 (lowest dur is 4 seconds, 1 count of 3 every 2 seconds
% and don't want zero as an option because it makes indexing textures complicated)
%so say we have 16 number options, the range would be 7-22  
% so the first impossible answer (for that range as a whole) is 23, so if
% we want 2/3rds of numbers to be impossible lets say the number line
% ranges from 1:66.

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
    r = numShowing;
    now = GetSecs();
end

globals.t = tTimeOut;
return