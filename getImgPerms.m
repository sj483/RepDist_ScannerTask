function [ImgPerms] = getImgPerms()

if exist('ImgPerms.mat','file')
    X = load('ImgPerms.mat');
    ImgPerms = X.ImgPerms;
    return
end

rng(196883);
nSubjects = 40;

% Image permulations (1-ordered, unique for each subject)
ImgPerms = nan(nImgs,nSubjects);
for iSubject = 1:nSubjects
    P = cellfun(@(iC) iC + (randperm(6)'),...
        num2cell(6*(randperm(9)-1)),'UniformOutput',false);
    ImgPerms(:,iSubject) = reshape(cell2mat(P),nImgs,1);
end

return