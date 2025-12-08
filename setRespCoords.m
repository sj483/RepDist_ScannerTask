function [xyEdgesResp, xyEdgesFrm, xyCentreResp] = setRespCoords(nX, cy)

%nX is width of screen, and cy is the centre of
%the screen height

imgWidth = round((10/128)*nX);    
outBlankX = round((20/128)*nX); 

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

xyEdgesFrm = nan(4,3);
for jj = 1:3
    xyEdgesFrm(1:2,jj) = xyEdgesResp(1:2,jj) - 20;
    xyEdgesFrm(3:4,jj) = xyEdgesResp(3:4,jj) + 20;
end

return