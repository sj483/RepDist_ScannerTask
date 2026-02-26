function [stoppedEarly] = runRun(subjectIdx,runId)

%% Clear the screen
sca;
close all;

%% Set file name for saving
if ~exist(sprintf('.%sOutputs',filesep),'dir')
    mkdir Outputs;
end
dateTimeStr = sprintf('%04d%02d%02dT%02d%02d%02d', ...
    round(clock)); %#ok<CLOCK>
saveFn = sprintf('.%sOutputs%s%02d_R%i_%s.mat',...
    filesep, filesep, subjectIdx, runId, dateTimeStr);

%% Create the globals structure
globals = setGlobals(subjectIdx,runId);

%% Set up IO port
globals = setIOPort(globals);
if globals.stoppedEarly
    stoppedEarly = true;
    return
end

%% Set-up PsychToolbox
globals = setUp(globals);

%% Create TaskIO
TaskIO = makeTaskIO(globals);

%% Wait for Scanner
[tScan0,globals] = waitForScanner(globals);

%% Trial loop
for iTIO = 1:size(TaskIO,1)

    switch TaskIO.trialType{iTIO}
        case 'Null'
            % Set tShow
            TaskIO.tShow(iTIO) = globals.t;

            % Draw a blank to the screen for 2.5 seconds
            globals = showBlank(2.5, globals);

        case 'CountDown'
            % Set tShow and send trigger
            TaskIO.tShow(iTIO) = globals.t;
            liSendTrig(TaskIO.trigId(iTIO),globals);

            % Extract the count-down specs
            countSpec = TaskIO.stimulus{iTIO};

            % Show the starting number for 1 second
            globals = showNum(countSpec.countStart, 1, globals);

            % Show the arrow for a variable number of seconds
            globals = showArrow(countSpec.countDur, globals);

            % Request a response, 2 second response window
            [response, tResponse, globals] = getCountResponse(...
                countSpec.scrollStart, globals);

            % Record the response and it's time
            TaskIO.response(iTIO) = response;
            TaskIO.tResponse(iTIO) = tResponse;

        case {'Typical','Oddball'}
            % Show a black for 0.5 seconds
            globals = showBlank(0.5, globals);

            % Set tShow and send trigger
            TaskIO.tShow(iTIO) = globals.t;
            liSendTrig(TaskIO.trigId(iTIO),globals);

            % Draw the image and wait 2 seconds while accepting responses
            [response, keyTime, globals] = ...
                showImg(TaskIO.textureIdx(iTIO), 2, globals);

            % Record the response and it's time
            TaskIO.response(iTIO) = response;
            TaskIO.tResponse(iTIO) = keyTime;

        otherwise
            error('Unrecognised trial type in TaskIO at iTrial=%i',iTIO);
    end

    % Set stoppedEarly
    [~, ~, keyCode] = KbCheck(-3);
    if keyCode(globals.escapeKey)
        globals.stoppedEarly = true;
    end

    % Save the data
    try
        save(saveFn, 'globals', 'TaskIO', 'tScan0');
    catch
        warning('Data not saved successfully on trial %i', iTIO);
    end

    % Escape
    if globals.stoppedEarly
        stoppedEarly = true;
        sca;
        warning('Terminated by user.');
        Screen('CloseAll');
        return
    end

end
Screen('CloseAll');

% Extract stoppedEarly
stoppedEarly = globals.stoppedEarly;
return