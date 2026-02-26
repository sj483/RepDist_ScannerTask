function [white, grey, black] = setMonochromes()
screens = Screen('Screens');
screenNumber = min(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = (white + black) / 2;
return 