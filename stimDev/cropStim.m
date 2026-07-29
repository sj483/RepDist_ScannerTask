function [] = cropStim(fnIn,thresh,fnOut)
% cropStim (v0.0)
% Sam Berens (s.berens@sussex.ac.uk)
%
% Systematically crop the image stimuli for use in study.
% This function assumes that the input images are saved as a PNG file ...
% ... and contain an alpha layer. 
%
% [] = cropStim(fnIn,thresh,fnOut)
% INPUTS:
%    - fnIn : Name/path of input file.
%    - thresh : Threshold for the proportion of non-empty pixels that ...
%               ... should be included in the output. 
%    - fnOut : Name/path of output file.

%% Read the input file (including the RBG and alpha layers)
[Img,~,Alpha] = imread(fnIn);

%% Binarize the alpha layer
BImg = imbinarize(Alpha);

%% Find the linear indices (and subscripts) of the non-empty pixels
idx = find(BImg);
[y,x] = ind2sub(size(BImg),idx);
XY = [x,y];

%% Find the centre of mass (C) of all non-empty pixels
n = numel(idx);
W = ones(1,n)./n;
C = W*XY;

%% Find the distance from each non-empty pixel to the centre
d = sqrt(sum((XY-C).^2,2));

%% Compute the distance CDF and the distance corresponding to thresh (r)
[cdf.f,cdf.x] = ecdf(d);
[~,cdf.ii] = min((cdf.f-thresh).^2);
r = cdf.x(cdf.ii);

%% Crop the input image around C, with width 2r
rect = [C-r,2*r,2*r];
CImg = imcrop(Img,rect);
CAlpha = imcrop(Alpha,rect);

%% Pad out the image
rightBottom = C + r;
leftTop = C - r;
x0 = leftTop(1);
x1 = rightBottom(1);
y0 = leftTop(2);
y1 = rightBottom(2);
if x0 < 0
    x0Pad = round(-x0);
else
    x0Pad = 0;
end
if (x1 - size(Img,2)) > 0
    x1Pad = round(x1 - size(Img,2));
else
    x1Pad = 0;
end
if y0 < 0
    y0Pad = round(-y0);
else
    y0Pad = 0;
end
if (y1 - size(Img,1)) > 0
    y1Pad = round(y1 - size(Img,1));
else
    y1Pad = 0;
end
padSizes = [...
    kron([y0Pad;size(CImg,1);y1Pad],[1;1;1]),...
    kron([1;1;1],[x0Pad;size(CImg,2);x1Pad])];
if size(CImg,3) == 3
    ECImg = [...
        uint8(ones(padSizes(1,1),padSizes(1,2),3).*128),...
        uint8(ones(padSizes(2,1),padSizes(2,2),3).*128),...
        uint8(ones(padSizes(3,1),padSizes(3,2),3).*128);...
        uint8(ones(padSizes(4,1),padSizes(4,2),3).*128),...
        CImg,...
        uint8(ones(padSizes(6,1),padSizes(6,2),3).*128);...
        uint8(ones(padSizes(7,1),padSizes(7,2),3).*128),...
        uint8(ones(padSizes(8,1),padSizes(8,2),3).*128),...
        uint8(ones(padSizes(9,1),padSizes(9,2),3).*128)];
else
    ECImg = [...
        uint8(ones(padSizes(1,1),padSizes(1,2),1).*128),...
        uint8(ones(padSizes(2,1),padSizes(2,2),1).*128),...
        uint8(ones(padSizes(3,1),padSizes(3,2),1).*128);...
        uint8(ones(padSizes(4,1),padSizes(4,2),1).*128),...
        CImg,...
        uint8(ones(padSizes(6,1),padSizes(6,2),1).*128);...
        uint8(ones(padSizes(7,1),padSizes(7,2),1).*128),...
        uint8(ones(padSizes(8,1),padSizes(8,2),1).*128),...
        uint8(ones(padSizes(9,1),padSizes(9,2),1).*128)];
end
NewAlpha = [...
    uint8(ones(padSizes(1,1),padSizes(1,2)).*0),...
    uint8(ones(padSizes(2,1),padSizes(2,2)).*0),...
    uint8(ones(padSizes(3,1),padSizes(3,2)).*0);...
    uint8(ones(padSizes(4,1),padSizes(4,2)).*0),...
    CAlpha,...
    uint8(ones(padSizes(6,1),padSizes(6,2)).*0);...
    uint8(ones(padSizes(7,1),padSizes(7,2)).*0),...
    uint8(ones(padSizes(8,1),padSizes(8,2)).*0),...
    uint8(ones(padSizes(9,1),padSizes(9,2)).*0)];

%% Mask out areas outside the circle
outsideIdx = FindOutsideIdx(size(NewAlpha),r);
NewAlpha(outsideIdx) = 0;

%% Resize to 830x830
REImg = imresize(ECImg,[830,830]);
RNewAlpha = imresize(NewAlpha,[830,830]); 

%% Write
imwrite(REImg,fnOut,'Alpha',RNewAlpha);
return