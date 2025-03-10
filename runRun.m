function [taskIO] = runRun(SubjectId, RunId)
    
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
    filesep, filesep, SubjectId, RunId, dateTimeStr);

  

    %% Create the globals structure
    clear global;
    globals = struct;
    globals.SubjectId = SubjectId;
   

    % Last argument below:
    % ... 0: Don't skip the sync-test
     % ... 2: Skip the sync-test
    Screen('Preference','SkipSyncTests', 1);

    %get image permutations from opseq
    runOrderStrt = setRunOrder;

    %% Set the globals
    globals = setGlobals(globals, runOrderStrt);
    
    %% Set-up PsychToolbox
    setUp(globals.window);
   % HideCursor();

    % build TaskIO
    [taskIO] = setTaskIO2(SubjectId, RunId, runOrderStrt,globals);
     

    
    %% Set IO port
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
        end
    end


    %% Wait for Scanner
    [tScan0,globals] = waitForScanner(globals);

    %TRIAL LOOP
    for trial = 1:numel(taskIO)
        if strcmp(taskIO(trial).category,"count")
            
            %Set trial charecteristics 
            startNum = taskIO(trial).Image_Id;
            globals = showNum(startNum, 1, globals);
            taskIO(trial).tShow = globals.t;
            durArrow = taskIO(trial).isiLength; %this is the duration of arrow presentation
            globals = showArrow(durArrow,globals);
            taskIO(trial).tShow = globals.t;
            %options is a mini struct of stuff needed for the counting
            %response page 
            options.startPos = taskIO(trial).startPos;
            options.correctResp = taskIO(trial).correctResp;
            options.opt1 = taskIO(trial).opt1;
            options.opt2 = taskIO(trial).opt2;
            % below is the duration of response page which is 
            % = 15sec(total 'trial' length) -1sec(in which number is shown) -Xsec(counting time while arrow is shown)
            options.dur = 14 - durArrow; 
           
            %DISPLAY & SAVE
            [rTexture, globals] = showCountOpts(options,globals);
            %r is the number of assigned to the texture they chose rather 
            % than the actual number shown in the texture so needs to be converted back
            r = find(globals.numTextures==rTexture); 
            taskIO(trial).response = r;
            Screen('CloseAll')
           
        else
            %DISPLAY & SAVE
            globals = showBlank(0.5, globals); 
            % globals.t is the time at which the last screen finished showing
            % i.e time which new screen should start
            taskIO(trial).tShow = globals.t; 

            imgDur = 2;
            %DISPLAY & SAVE
            [r,globals] = showImg(trial,imgDur,globals); 
            taskIO(trial).response = r;
        end   

        try
            save(targetFn, "taskIO", "tScan0", "globals");
        catch
            warning('Data not saved successfully on trial %i', iT);
        end

        %% Escape
        [~, ~, keyCode] = KbCheck(-3);
        if keyCode(globals.escapeKey)
            sca;
            error('Terminated by user.');
        end
    end

   return 


