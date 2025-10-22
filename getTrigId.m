function [trigId] = getTrigId(imgId,obStatus)
trigId = num2str(obStatus); %this is 1 for oddBall, 0 for normal image
category = ceil(imgId/6);
% category = category-1; %zero order them...
imgNum = imgId - ((category-1)*6);
imgNum = imgNum -1 ;%zero ordered 
trigId = [trigId,dec2bin(category,4)];
trigId = [trigId,dec2bin(imgNum,3)];
%change it back because liTrig expexts ints 
trigId = bin2dec(trigId);
return



