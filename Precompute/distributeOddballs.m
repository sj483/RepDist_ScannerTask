%% Experiment Parameters Setup
% Define the basic parameters of the fMRI experiment.
nRuns = 4;       % Number of fMRI runs in the entire experiment.
nReps = 5;      % Number of times each stimulus is repeated per run.
nCats = 9;      % Number of image categories.
nStim = 6;      % Number of distinct images per category.

% Compute additional quantities based on the above parameters.
nImgs = nCats * nStim;    % Total number of images (all categories combined).
nPresPerRun = nReps * nImgs; % Total number of image presentations per run.

% Define target (oddball) parameters.
pTarget = 10/100;              % Proportion of presentations that should have oddball targets (10%).
nTargetsPerRun = pTarget * nPresPerRun; % Expected number of target presentations per run.
nTargetsPerImgPerRun = nTargetsPerRun / nImgs; % Average number of oddball targets per image in one run.
nTargetsPerImg = nTargetsPerImgPerRun * nRuns;    % Total oddball targets for each image across all runs.
% Note: With the default parameters, each image appears 5 times per run across 4 runs.
%       Thus nTargetsPerRun becomes 27, leading to 27/54 = 0.5 per image per run,
%       and overall 0.5*4 = 2 targets per image across the experiment.

%% Stimulus and Timing Index Setup
% Create a categorical array for images.
sImgs = categorical((1:(nCats*nStim)) - 1);
% The images are labeled from 0 to (nCats*nStim - 1) for indexing purposes.

% Create run and repetition indices using Kronecker products.
% iRun: A column vector indicating the run index (0-based) for each repetition instance.
iRun = kron((1:nRuns)' - 1, ones(nReps, 1));
% iRep: A column vector indicating the repetition number (0-based) within each run.
iRep = kron(ones(nRuns, 1), (1:nReps)' - 1);

%% Initialization for Target Schedule Optimization
% Initialize the structure 'Best' to store the best target schedule found
% along with its associated performance statistic (variance).
Best.M = zeros(numel(iRun), numel(sImgs)); % Matrix to store candidate assignments.
Best.stat = Inf;                           % Initialize best statistic to infinity.
nIter = 1e2;    % Number of iterations for the randomized search (can be increased for more precise optimization).
iIter = 0;      % Counter for iterations.

% Create a matrix to sum the target counts for each run.
% SumReps is built using a Kronecker product: it is an identity matrix for runs (size: nRus x nRus)
% with each entry replaced by a row vector of ones of length nReps.
% This matrix allows summing across the repetitions belonging to the same run.
SumReps = kron(eye(nRuns), ones(1, nReps));

% Open a waitbar to provide user feedback during the iterations.
fh = waitbar(0, 'Running...');

%% Iterative Randomized Search for Optimal Target Scheduling
% The aim is to assign oddball target events to specific presentations such that:
% 1. Each image is assigned exactly 2 targets across runs.
% 2. The distribution of targets is as uniform as possible both per repetition (nTargetsPerRep)
%    and per fMRI run (nTargetsPerRun), which is assessed by minimizing the sum of variances.
while iIter < nIter
    iIter = iIter + 1;
    
    % Initialize the candidate assignment matrix for this iteration.
    % Each row corresponds to a specific presentation repetition (combining run and rep),
    % and each column corresponds to an image.
    % A value of 1 indicates the presence of an oddball target at that presentation of an image.
    IsTarget_Reps = zeros(numel(iRun), numel(sImgs));
    
    % Loop through each image and randomly assign target appearances.
    % For every image, randomly select:
    %   - 2 out of the available runs, and
    %   - 2 out of the repetition indices within a run.
    % This enforces that each image receives exactly 2 oddball targets across the experiment.
    for iImg = 1:numel(sImgs)
        % Randomly choose 2 runs from the available runs without replacement.
        selectedRuns = randsample((1:nRuns)', 2, false);
        % Randomly choose 2 repetitions for target assignment without replacement.
        selectedReps = randsample((1:nReps)', 2, false);
        % Compute the corresponding row indices in the assignment matrix.
        % The formula (selectedRuns-1)*nReps + selectedReps converts run and repetition pairs
        % into unique indices corresponding to rows in IsTarget_Reps.
        iRow = (selectedRuns - 1) * nReps + selectedReps;
        % Set the assignment for the current image at the chosen repetition rows to 1.
        IsTarget_Reps(iRow, iImg) = 1;
    end
    
    % Calculate the total number of targets assigned for each repetition instance.
    % nTargetsPerRep is a column vector where each entry is the sum of target events across all images
    % for a particular repetition (i.e., one combination of run and rep).
    nTargetsPerRep = sum(IsTarget_Reps, 2);
    
    % Sum the targets for each run using the pre-computed SumReps matrix.
    % nTargetsPerRun becomes a column vector where each entry indicates the total number of targets
    % in a single fMRI run.
    nTargetsPerRun = SumReps * nTargetsPerRep;
    
    % Define a performance statistic for the current assignment.
    % Here, the objective is to minimize the variability in the number of targets assigned across
    % both repetitions (within-run) and runs. This is measured by the sum of the variances.
    stat = var(nTargetsPerRep) + var(nTargetsPerRun);
    
    % Update the "best" assignment if the current candidate has a lower variability.
    if stat < Best.stat
        Best.M = IsTarget_Reps;
        Best.stat = stat;
    end
    
    % Update the waitbar occasionally (every 197 iterations).
    % Note: With nIter = 100, this condition might not be met; however, if nIter is increased,
    % then the progress indicator will update accordingly.
    if mod(iIter, 197) == 0
        waitbar(iIter/nIter, fh);
    end
end

% Close the waitbar after optimization is complete.
close(fh);

%% Display the Results of the Best Found Assignment
% nTargetsPerRep: Distribution of oddball targets for each repetition (across runs and reps).
disp(nTargetsPerRep);
% nTargetsPerRun: Distribution of oddball targets for each fMRI run.
disp(nTargetsPerRun);
