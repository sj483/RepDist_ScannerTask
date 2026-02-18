function [OddballDist] = getOddballDist()
X = load('OddballDist.mat');
OddballDist = X.OddballDist;
return