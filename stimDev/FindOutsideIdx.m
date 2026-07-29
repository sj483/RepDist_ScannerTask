function [OutsideIdx] = FindOutsideIdx(ImSize,r)
[y,x] = ind2sub(ImSize,(1:prod(ImSize))');
YX = [x,y];
C = (ImSize-1)./2 + 1;
d = sqrt(sum((YX-C).^2,2));
IsOutside = d>r;
IsOutside = reshape(IsOutside,ImSize);
OutsideIdx = find(IsOutside);
return