function [imgId] = imgName2imgId(imgName)

% Check input and convert to cell if needed
if ischar(imgName)
    imgName = {imgName};
elseif ~iscell(imgName)
    error('Input must be either a char or cell');
end

% Assign image categories to IDs
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

% Get the category ID (0-ordered)
catId = cellfun(@(s)find(contains(catNames,s(1:3))),imgName) - 1;

% Get the imgNum (0-ordered)
imgNum = cellfun(@(s)str2double(s(4)),imgName);

% Construct the imgId (0-ordered)
imgId = 6.*catId + imgNum;
return