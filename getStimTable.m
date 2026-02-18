function [StimTable] = getStimTable(imgPerm)

% Ensure imgPerm is valid (1-ordered + group contiguous)
if testImgPerm(imgPerm)
    error('Invalid imgPerm.');
end

% Set a sorted list of category names
catNames = {
    'Ani'; % 0
    'Art'; % 1
    'Fac'; % 2
    'Foo'; % 3
    'Lin'; % 4
    'Obj'; % 5
    'Pla'; % 6
    'Spa'; % 7
    'Tex'; % 8
    };

% Number of images per category
nImgsPerCat = 6;

% Size of StimTable
nStim = numel(catNames)*nImgsPerCat;

% Preallocate the variables
StimTable = struct;
StimTable.catName = cell(nStim,1);
StimTable.imgName = cell(nStim,1);
StimTable.catId = nan(nStim,1); % 0-ordered
StimTable.imgId = nan(nStim,1); % 0-ordered
StimTable.trigId_Typical = nan(nStim,1);
StimTable.trigId_Oddball = nan(nStim,1);
StimTable.imgPath_Typical = cell(nStim,1);
StimTable.imgPath_Oddball = cell(nStim,1);

% Loop through to populate the variables
iIn = 0;
for iCat = 1:numel(catNames)
    catName = catNames{iCat};
    for iImg = 1:nImgsPerCat
        iIn = iIn + 1;
        imgName = sprintf('%s%i',catName,iImg-1);
        StimTable.catName{iIn} = catName;
        StimTable.imgName{iIn} = imgName;
        StimTable.imgPath_Typical{iIn} = fullfile('.','Imgs','Typicals',...
            [imgName,'.png']);
        StimTable.imgPath_Oddball{iIn} = fullfile('.','Imgs','Oddballs',...
            [imgName,'.png']);
    end
end

StimTable.imgId = imgName2imgId(StimTable.imgName);
StimTable.catId = imgId2catId(StimTable.imgId);
StimTable.trigId_Typical = getTrigId(StimTable.imgId,0);
StimTable.trigId_Oddball = getTrigId(StimTable.imgId,1);

% Create the unsorted StimTable
StimTable = struct2table(StimTable);

% Sort the rows of the table
StimTable = StimTable(imgPerm,:);
return

function [fail] = testImgPerm(imgPerm)
M = kron(eye(9),ones(1,6)./6);
a = M*imgPerm;
fail = sum((sort(a)-(3.5:6:51.5)').^2) > 1e-16;
return