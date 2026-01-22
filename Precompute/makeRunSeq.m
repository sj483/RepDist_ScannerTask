%Seq contains a field per run e.g. Seq.Run1, and each field contains...
% a [57*5,1] vector

seed = 42;
rng(seed, 'twister');

for ii=1:4
    repSize = 54;
    nReps = 5;
    %how big the rep will be after adding 3 nans
    newRepSize = repSize + 3;

    for rr = 1:nReps
        % Extract current repeat from whole run's run order
        rep = randperm(54)';

        % Choose 3 unique random NaN insert positions
        insertIdx = sort(randperm(newRepSize, 3));

        % Preallocate Rep with NaNs
        repWithNaNs = NaN(newRepSize, 1);

        % Fill positions that are NOT in insertIdx
        toCopy = true(newRepSize, 1);
        toCopy(insertIdx) = false;

        % Fill the non-NaN positions
        repWithNaNs(toCopy) = rep;

        % Add to the new Run 
        if rr==1
            cRun = repWithNaNs;
        else
            cRun = [cRun;repWithNaNs]; %#ok<AGROW>
        end
    end

Seq.(sprintf('Run%i',ii)) = cRun;

end

save('RunSequence.mat','Seq');