function [r, globals] = requestResponse(duration, globals)
allowableKeys = globals.upKey;
tStart = globals.t;
tTimeOut = (tStart + duration);
r = NaN;
globals.respT = NaN;
now = GetSecs();
while now < tTimeOut
    [keyIds, keyTime] = liKeyWait(allowableKeys, tTimeOut);
    
    
    if ismember(globals.upKey,keyIds) && isnan(r)
        %liSendTrig(1, globals);
        r = 1;
        globals.respT = keyTime;
    end
    now = GetSecs();
end
return