function [taskIO] = runRun(subjectId,runId,perm,startNums,skip)
    
    %% Clear the screen
    sca;
    close all;
    PsychDefaultSetup(2);


    % setUp for saving the output
    if ~exist(sprintf('.%sOutputs',filesep),'dir')
        mkdir Outputs
    end

    dateTimeStr = sprintf('%04d%02d%02dT%02d%02d%02d',round(clock)); %#ok<CLOCK>
    targetFn = sprintf('.%sOutputs%s%s_R%i_%s.mat',...
    filesep, filesep, subjectId, runId, dateTimeStr);

  

    %% Create the globals structure
    clear global;
    globals = struct;
    globals.subjectId = subjectId;
    globals.runId = runId; 
    globals.skip = skip;
   

    % Last argument below:
    % ... 0: Don't skip the sync-test
    % ... 2: Skip the sync-test
    %.....1:This will shorten the  maximum duration of the sync tests to 3
    % seconds worst case and it will
    % force Psychtoolbox to continue with execution of your script, even if the
    % sync tests failed completely
    % Screen('Preference','SkipSyncTests', 1);

    %get current run's order from seq struct
    seq = load('RunSequence.mat');
    fieldname = sprintf('%s%i','Run',runId);
    runOrder = seq.Seq.(fieldname);

    %get the number which the participant will be counting down from 
    %in the counting trials of this run
    startNums = startNums.(fieldname);

    %% Set the globals
    globals = setGlobals(globals,perm);
    

    % build TaskIO
    taskIO = setTaskIO(runOrder, globals, startNums);
     
   
    % Set IO port
    globals.sendTriggers = true;
    try
        [globals.portObj,globals.portAddress] = setIOPort();
        io64(globals.portObj,globals.portAddress,0);
        choice = questdlg(...
            sprintf('Successfully setup IO port.%cWould you like to continue?',10),...
            'Continue?', ...
            'Exit execution','Let''s go!','Exit execution');
        switch choice
            case 'Exit execution'
                return
            case 'Let''s go!'
                imgDur = 2;
                HideCursor();
        end
    catch
        choice = questdlg(...
            sprintf('Failed to setup IO port.%cWhat would you like to do?',10),...
            'IO port not working', ...
            'Exit execution','Continue; I am testing','Exit execution');
        switch choice
            case 'Exit execution'
                return
            case 'Continue; I am testing'
                globals.sendTriggers = false;
                imgDur = 0.5; 
        end
    end


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
            save(targetFn, "taskIO", "tScan0", "globals");
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
   Screen('CloseAll')

   return 


