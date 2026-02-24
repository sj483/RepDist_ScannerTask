function [] = makeArrowImg()

% Create a new figure
fh = figure;

% Set the axis limits to 200 x 200
axis([0 200 0 200]);

% Set the aspect ratio to ensure equal lengths
pbaspect([1 1 1]);

% Set background
set(gca, 'Color', [0.5,0.5,0.5]);

% Remove axis lines
set(gca, 'XColor', 'none', 'YColor', 'none');

% Expand axis to fill figure
set(gca, 'Position', [0 0 1 1]);

% Set figure size to be square
fh.Units = 'pixels';
fh.Position(3:4) = [200 200];
fh.Units = 'inches';
fh.Position = [0 0 2 2];  % 2 inches * 2 inches
fh.PaperUnits = 'inches';
fh.PaperPosition = [0 0 2 2];

% Set paper mode to auto so it saves as it appears
fh.PaperPositionMode = 'auto';
fh.InvertHardcopy = 'off';

text(100, 100, '$\leftarrow$',...
    'Interpreter','latex',...
    'Color', 'w',...
    'FontSize', 100,...
    'HorizontalAlignment', 'center',...
    'VerticalAlignment', 'middle');
print(fh, 'Arrow.png', '-dpng', '-r100');  % Save as PNG at 100 DPI

close all;
return