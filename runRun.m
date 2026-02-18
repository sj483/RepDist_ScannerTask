function [stoppedEarly] = runRun(subjectId,runId)

%% Clear the screen
sca;
close all;

%% Set file name for saving
if ~exist(sprintf('.%sOutputs',filesep),'dir')
    mkdir Outputs;
end
dateTimeStr = sprintf('%04d%02d%02dT%02d%02d%02d', ...
    round(clock)); %#ok<CLOCK>
saveFn = sprintf('.%sOutputs%s%s_R%i_%s.mat',...
    filesep, filesep, subjectId, runId, dateTimeStr);

%% Create the globals structure
globals = setGlobals(subjectId,runId);

%% Set up IO port
globals = setIOPort(globals);

%% Create TaskIO
TaskIO = makeTaskIO(globals);

%% Wait for Scanner
[tScan0,globals] = waitForScanner(globals);

%TRIAL LOOP
for trial = 1:numel(taskIO)
    if strcmp(taskIO(trial).type,"countingTrial")

        %Display the number from which to count down from
        startNum = taskIO(trial).startNum;
        globals = showNum(startNum, 1, globals);
        taskIO(trial).tShow = globals.t;
        %Display arrow for duration of counting period
        durArrow = taskIO(trial).isiLength;
        globals = showArrow(durArrow,globals);
        taskIO(trial).tShow = globals.t;
        %options is a mini struct of stuff needed for the counting
        %response page
        options.scrlStart = taskIO(trial).scrlStart;
        options.dur = 2; % response time always 2 seconds

        %Display scrolling answer page
        [r, globals] = showScroll(options,globals);
        taskIO(trial).response = r;
    elseif strcmp(taskIO(trial).type,"null")
        %Display Null trial (blank screen for 2.5 seconds)
        globals = showBlank(2.5, globals);
        taskIO(trial).tShow = globals.t;
    else %this is both target/non target trials
        %Display ISI
        globals = showBlank(0.5, globals);
        % globals.t is the time at which the last screen finished showing
        % i.e time which new screen should start
        taskIO(trial).tShow = globals.t;

        %Set trial charecteristics
        %imgDur = 2; unless you're testing...
        imgTexture = taskIO(trial).textureId;
        trigId = taskIO(trial).trigId;
        %Display image stimulus
        [r,globals] = showImg(imgTexture,imgDur,globals);
        liSendTrig(trigId + 8,globals);
        taskIO(trial).response = r;
        taskIO(trial).respT = globals.respT;
        if strcmp(taskIO(trial).type, 'oddBall')
            % Oddball trial
            if isnan(r)
                taskIO(trial).correctResp = 0;
            else
                taskIO(trial).correctResp = 1;
            end
        else
            % Non-oddball trial
            if ~isnan(r)
                taskIO(trial).correctResp = 0;
            end
            % Otherwise leave it as NaN (default)
        end
    end

    try
        save(saveFn, "taskIO", "tScan0", "globals");
    catch
        warning('Data not saved successfully on trial %i', trial);
    end

    %% Escape
    [~, ~, keyCode] = KbCheck(-3);
    if keyCode(globals.escapeKey)
        sca;
        error('Terminated by user.');
    end
end
Screen('CloseAll');

% Extract stoppedEarly
stoppedEarly = globals.stoppedEarly;
return