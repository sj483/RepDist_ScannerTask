function [globals] = setIOPort(globals)
globals.sendTriggers = true;

try
    config_io;
    globals.portObj = io64;
    globals.portStatus = io64(globals.portObj);
    globals.portAddress = hex2dec('3FF8');
    io64(globals.portObj,globals.portAddress,0);

    choice = questdlg(sprintf(....
        'Successfully setup IO port.%cWould you like to continue?',10),...
        'Continue?', ...
        'Exit execution','Let''s go!','Exit execution');
    switch choice
        case 'Exit execution'
            Screen('CloseAll');
            globals.stoppedEarly = true;
            return
        case ''
            Screen('CloseAll');
            globals.stoppedEarly = true;
            return
        case 'Let''s go!'
            % Continue execution.
        otherwise
            Screen('CloseAll');
            globals.stoppedEarly = true;
            return
    end
catch
    choice = questdlg(sprintf(...
    'Failed to setup IO port.%cWhat would you like to do?',10),...
        'IO port not working', ...
        'Exit execution','Continue; I am testing','Exit execution');
    switch choice
        case 'Exit execution'
            Screen('CloseAll');
            globals.stoppedEarly = true;
            return
        case 'Continue; I am testing'
            globals.sendTriggers = false;
        case ''
            Screen('CloseAll');
            globals.stoppedEarly = true;
            return
        otherwise
            Screen('CloseAll');
            globals.stoppedEarly = true;
            return
    end
end

return
