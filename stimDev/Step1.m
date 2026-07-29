%% Step 1 crops images around the image centroid in a circular fashion and resizes them 

% Define the thresholds for each image category
threshs = {...
    'Ani0.png',1.0;
    'Ani1.png',1.0;
    'Ani2.png',1.0;
    'Ani3.png',1.0;
    'Ani4.png',1.0;
    'Ani5.png',1.0;
    'Art0.png',0.5;
    'Art1.png',0.5;
    'Art2.png',0.5;
    'Art3.png',0.5;
    'Art4.png',0.5;
    'Art5.png',0.5;
    'Foo0.png',1.0;
    'Foo1.png',1.0;
    'Foo2.png',1.0;
    'Foo3.png',1.0;
    'Foo4.png',1.0;
    'Foo5.png',1.0;
    'Lin0.png',1.0;
    'Lin1.png',1.0;
    'Lin2.png',1.0;
    'Lin3.png',1.0;
    'Lin4.png',1.0;
    'Lin5.png',1.0;
    'Obj0.png',1.0;
    'Obj1.png',1.0;
    'Obj2.png',1.0;
    'Obj3.png',1.0;
    'Obj4.png',1.0;
    'Obj5.png',1.0;
    'Pla0.png',0.97;
    'Pla1.png',0.97;
    'Pla2.png',0.97;
    'Pla3.png',0.97;
    'Pla4.png',0.97;
    'Pla5.png',0.97;
    'Spa0.png',1.0;
    'Spa1.png',1.0;
    'Spa2.png',1.0;
    'Spa3.png',1.0;
    'Spa4.png',1.0;
    'Spa5.png',1.0;
    'Tex0.png',0.80;
    'Tex1.png',0.80;
    'Tex2.png',0.76; 
    'Tex3.png',0.70;
    'Tex4.png',0.56;
    'Tex5.png',0.60};

%% Get source file info
cd ##;
imgList = dir('*.png');
imgCats = cellfun(@(s)s(1:3),{imgList.name}',...
    'UniformOutput',false);
imgPaths = cellfun(@(s)[pwd,filesep,s],{imgList.name}',...
    'UniformOutput',false);
cd ..;

%% Get destination file paths
try
    cd ###;
catch
    mkdir ###;
    cd ###;
end
outPaths = cellfun(@(s)[pwd,filesep,s],{imgList.name}',...
    'UniformOutput',false);
cd ..;

%% Loop
for iI = 1:numel(imgPaths)
    if strcmp(imgCats{iI},'Fac')
        copyfile(imgPaths{iI},outPaths{iI});
    else
        ct = threshs{strcmp(imgList(iI).name,threshs(:,1)),2};
        cropStim(imgPaths{iI},ct,outPaths{iI});
    end
end