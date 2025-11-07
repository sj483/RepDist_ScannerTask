% Number of subjects
nSubs = 40; % change as needed

% Generate subject IDs Subject-%02d', SubjectN)
subjectIds = arrayfun(@(x) sprintf('Subject_%02d', x), (1:nSubs)', 'UniformOutput', false);

% Initialize structure
perms = struct();

for ii = 1:nSubs
    subjID = subjectIds{ii};
    %Initialize rng with seed
    rng(ii, 'twister');
    % Randomized category permutation (1–9)
    perms.(subjID).catPerm = randperm(9)';
    % Randomized image permutations (9 cells, each with 1–6 in random order)
    imgPermCell = cell(9, 1);
    for c = 1:9
        imgPermCell{c} = randperm(6)';  %Remember this is the 2nd state after the seed has been set if you are trying to reinstate it!
    end
    perms.(subjID).imgPerm = imgPermCell;
end


save('taskPerms.mat','perms');
