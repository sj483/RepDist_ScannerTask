function [runOrderStrt] = setRunOrder(opseq)

%these numbers are used to encode the category and identity of the
%different stimuli so refer to them when making opseq
% Ani = [1:6];
% Art = [7:12];
% Fac = [13:18];
% Foo = [19:24];  
% Ifa = [25:32];
% Lin = [33:38];
% Obj = [39:42];
% Pla = [43:48];
% Spa = [49:54];

if nargin == 0
    runOrder = 1:54; %making run order random for now but...
    runOrder= Shuffle(runOrder); % ..switch out for opSeq order here !!!
else
    runOrder = opseq;
end    
%the category labels below align with the naming of the image files - will
%break if they are changed!!
categories = ["Ani", "Art", "Fac", "Foo", "Ifa", "Lin","Obj", "Pla", "Spa"];

%% Preallocate the TaskIO structure
numImgs = 54; % num images + num counting task(present + respond) 
runOrderStrt = repmat((struct(... %imageId, Category, Dur, Response, tResponse 
    'Category', [], ...
    'imageId', NaN, ...
    'fPath', [])), ...% you'll need this for the Counting task
    numImgs,1);

%assign the struct the img Id, category, and file name 
for ii = 1:numImgs
    cImgId = runOrder(ii); %extracts the id of the image
    runOrderStrt(ii).imageId = cImgId;
    catIdx = ceil(cImgId/6); %calculates the category based on the img id (relies on each category having 6 members)
    runOrderStrt(ii).Category = categories(catIdx);
    nmbr = (cImgId - 6*(catIdx-1))-1; %this calculates what the number will be in the image name based on its id
    runOrderStrt(ii).fPath = fullfile(cd, '##', sprintf('%s%i%s', runOrderStrt(ii).Category, nmbr, '.png'));
end
return