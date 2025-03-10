function [textures] = setTextures(window, taskIO)



%here we syphon off the fPaths from TaskIO which have already been put in the correct run order 
imgList = cell(numel(taskIO),1);
for ii = 1:numel(taskIO)
    imgList{ii} = taskIO(ii).fPath;
end

nonEmptyCells = ~cellfun(@isempty, imgList);
newArray = imgList(nonEmptyCells);

%then we turn all these paths into actual files
imgFiles = cell(numel(newArray),1); 
for jj = 1:numel(imgFiles)
    imgFiles{jj} = imread(newArray{jj});
end

% Make the 6 sparks into textures
textures = nan(numel(imgFiles),1);
for tt = 1:numel(textures)
    textures(tt) = Screen('MakeTexture', window, imgFiles{tt});
end
return