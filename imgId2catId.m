function [catId] = imgId2catId(imgId)
catId = floor(imgId./6);
return