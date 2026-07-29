cd ####;
imgList = dir('*.png');
figure;
for ii = 1:numel(imgList)
    [img,~,alpha] = imread(imgList(ii).name);
    
    img = double(img);
    alpha = double(alpha);
    if size(img,3) > 1
        img = img.*(alpha./255) + ones([size(alpha),3]).*128.*(1-(alpha./255));
    else
        img = img.*(alpha./255) + ones([size(alpha),1]).*128.*(1-(alpha./255));
    end
    img = uint8(img);
    alpha = uint8(alpha);

    imshow(img);
    pause(2);
end
cd ..;