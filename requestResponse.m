function [r, globals] = requestResponse(duration, globals)
allowableKeys = globals.acceptKey;

tStart = globals.t;

tTimeOut = (tStart + duration);
r = NaN;
now = GetSecs();
while now < tTimeOut
    [keyIds, keyTime] = liKeyWait(allowableKeys, tTimeOut);
    globals.t = keyTime;
    
    if ismember(globals.acceptKey,keyIds) && isnan(r)
        %liSendTrig(1, globals);
        r = 1;
    end
    now = GetSecs();
end

%globals.t = tTimeOut;
return