function [r,globals] = showCountOpts(options,globals)
allowableKeys = [globals.scrollKey, globals.acceptKey];
%cursorPos starts on a random option defined by TaskIO and then is updated when they scroll through the options
cursorPos = options.startPos; 

% we unpack the number options and build the response array
%from the textures corresponding to the relevant numbers for this trial
correctResp = globals.numTextures(options.correctResp);
opt1 = globals.numTextures(options.opt1);
opt2 = globals.numTextures(options.opt2);
respArray = [correctResp, opt1, opt2];
respArray = Shuffle(respArray);


tStart = drawRespArray(respArray,cursorPos, [0,0,1].*globals.white, globals);

tTimeOut = (tStart + options.dur); 
r = NaN;
now = GetSecs();
tLastValidScroll = -Inf;
while now < tTimeOut
    [keyIds, keyTime] = liKeyWait(allowableKeys, tTimeOut);
    globals.t = keyTime;
    if ismember(globals.scrollKey,keyIds) && isnan(r)
        if keyTime > (tLastValidScroll + 0.25)
            %liSendTrig(0, globals);
            cursorPos = (mod((cursorPos), 3)) + 1; 
            drawRespArray(respArray, cursorPos, [0,0,1].*globals.white, globals);
            tLastValidScroll = keyTime;
        end
    elseif ismember(globals.acceptKey,keyIds) && isnan(r)
       % liSendTrig(1, globals);
        r = respArray(cursorPos);
        drawRespArray(respArray, cursorPos, [0,1,1].*globals.white, globals);
        %tRespo = keyTime;
    end
    now = GetSecs();
end

globals.t = tTimeOut;
Screen('Close', respArray)
return