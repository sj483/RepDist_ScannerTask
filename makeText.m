function [txtTexture] = makeText(textX, globals)
cd(['Imgs',filesep,'CountTask']);
if strcmp(textX,"arrow")
    imgName = textX;
else
    imgName = sprintf('%03d%i', textX);
end
textImg = imread([imgName,'.png']);
txtTexture = Screen('MakeTexture', globals.window, textImg);
cd(['..',filesep,'..']);
return