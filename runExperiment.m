function [taskIO] = runExperiment(SubjectId)


%%%%%%%%% this stuff is from the old set and needs to be change wont
%%%%%%%%% currently work

taskIO = setTaskIO2(SubjectId, RunId);

%% Create the globals structure
clear global;
globals = struct;
globals.SubjectId = SubjectId;

%% Set the globals
globals = setGlobals(globals, taskIO);

%% Set-up PsychToolbox
setUp(globals.window);

setUp(window);



