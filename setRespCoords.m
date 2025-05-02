function [xyEdgesResp, xyCentreResp] = setRespCoords(nX, nY, cy)

%nX is width of screen and nY is height of screen, and cy is the centre of
%the screen height

numRows = 1;
numPerRow = 3;
imgWidth = round((10/128)*nX);    % values for spark array were imgWidth: 14, outBlankX: 10, outBlankY: 6 all out of 64
outBlankX = round((20/128)*nX); %change back to 20/128
%outBlankY = round((57/128)*nY);

%% Calculate the space between images in the x and y directions
%inBlankX = (nX - numPerRow*imgWidth - outBlankX*2) / (numPerRow - 1);
%inBlankY = (nY - numRows*imgWidth - outBlankY*2) / (numRows - 1);

%% Calculate the x and y co-ords of the centres of each response textures
xCents =  linspace(...
        outBlankX + imgWidth/2, .... startX
        nX - (outBlankX + imgWidth/2), .... endX
        3);

xyCentreResp = nan(2,3);
xyCentreResp(1,:) = repmat(xCents,1,1);
xyCentreResp(2,:) = cy;  % we want the number options to be centred on the screen

%% Calculate the x and y co-ords of the edges of each response texture
xyEdgesResp = nan(4,3); % Each column will contain 4 numbers...
% 1: the x-coordinate of the left edge of the rectangle;
% 2: the y-coordinate of the top edge of the rectangle;
% 3: the x-coordinate of the right edge of the rectangle;
% 4: the y-coordinate of the bottom edge of the rectangle;
for iImg = 1:3
    xyEdgesResp(:,iImg) = CenterRectOnPoint(...
        [0 0 imgWidth imgWidth],...
        xyCentreResp(1, iImg), xyCentreResp(2, iImg));
end

return