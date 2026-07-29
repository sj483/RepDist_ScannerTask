%% Step 2 normalises the mean and SD of luminance in each image to match the group

try
    cd ####;
catch
    mkdir ####;
    cd ####;
end
destDir = pwd;
cd ..;

cd ###;
imgList = dir('*.png');
%The ‘Lin’ and ‘Tex’ stimulus groups were excluded from this procedure 
% because they were close to isoluminant grey; adjusting them towards 
% the set's mean luminance would have made them difficult to distinguish 
% from the background. 
imgList = imgList(~contains({imgList.name}','Lin'));
imgList = imgList(~contains({imgList.name}','Tex')); 

oldIms = cell(numel(imgList),1);
masks =  cell(numel(imgList),1);
rgbMasks = cell(numel(imgList),1);
labIms = cell(numel(imgList),1);
lumChannel = cell(numel(imgList),1);

for ii = 1:numel(imgList)
    [oldIms{ii},~,masks{ii}] = imread(imgList(ii).name);
    if size(oldIms{ii},3) < 3
        oldIms{ii} = repmat(oldIms{ii},1,1,3);
    end 
    rgbMasks{ii} = masks{ii};
    rgbMasks{ii} = rgbMasks{ii}./255;
    labIms{ii} = rgb2lab(oldIms{ii});
    lumChannel{ii} = labIms{ii}(:,:,1);
end

%Normalise the lum channel then convert back to rgb values before saving
lumChannel_matched = lumMatch(lumChannel,rgbMasks);
for ii = 1:numel(imgList)
labIms{ii}(:,:,1) = lumChannel_matched{ii};
end
rgbOut = cellfun(@(x) lab2rgb(x),labIms, 'UniformOutput', false);

for ii = 1:numel(rgbOut)
    fName = sprintf('%s%s%s',destDir,filesep,imgList(ii).name);
    imwrite(rgbOut{ii},fName,'Alpha',masks{ii});
end
%Move over remaining images left out of the lumMatch process  
copyfile('Lin*.png',destDir);
copyfile('Tex*.png',destDir);

cd ..;