%% Step 0 Blends edges of foreground with isoluminant grey 
try
    cd ##;
catch
    mkdir ##;
    cd ##;
end
destDir = pwd;
cd ..;

%%
cd #;
imgList = dir('Spa*.png');
gain = 1.3;
for ii = 1:numel(imgList)

    [img,~,alpha] = imread(imgList(ii).name);
    
    img = double(img);
    alpha = double(alpha);
    img = gain.*img.*(alpha./255) + ones([size(alpha),3]).*128.*(1-(alpha./255));
    img = uint8(img);
    alpha = uint8(alpha);

    img = rgb2gray(img);
    imwrite(img,sprintf('%s%s%s',destDir,filesep,imgList(ii).name),'Alpha',alpha);
end
cd ..;

%%
cd #;
imgList = dir('*.png');
imgList = imgList(~contains({imgList.name}','Spa'));

for ii = 1:numel(imgList)

    [img,~,alpha] = imread(imgList(ii).name);

    img = double(img);
    alpha = double(alpha);
    img = img.*(alpha./255) + ones([size(alpha),3]).*128.*(1-(alpha./255));
    img = uint8(img);
    alpha = uint8(alpha);
    
    imwrite(img,sprintf('%s%s%s',destDir,filesep,imgList(ii).name),'Alpha',alpha);
end
cd ..;