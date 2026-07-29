%% Step 3 - Adds circles to images to produce Oddball stimuli 

try
    cd #####;
catch
    mkdir #####;
    cd #####;
end
destDir = pwd;
cd ..;


cd ####;
imgList = dir('*.png');
cd ..

for ii= 1:numel(imgList)
    fName = imgList(ii).name;
    makeDots(fName);
end