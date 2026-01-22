function [] = makeArrowImg()

% Create a new figure
fh = figure;

% Set the axis limits to 200 x 200
axis([0 200 0 200]);

% Set the aspect ratio to ensure equal lengths
pbaspect([1 1 1]);
set(gca, 'Color', [0.5,0.5,0.5]); % Set background to black
set(gca, 'XColor', 'none', 'YColor', 'none'); % Remove axis lines

% Expand axis to fill figure
set(gca, 'Position', [0 0 1 1]);

% Set figure size to be square
fh.Units = 'pixels';
fh.Position(3:4) = [200 200]; % Make it nicely square (larger than 830 to allow room)

fh.Units = 'inches';
fh.Position = [0 0 2 2];  % 2 in × 2 in
fh.PaperUnits = 'inches';
fh.PaperPosition = [0 0 2 2];
% Set paper mode to auto so it saves as it appears
fh.PaperPositionMode = 'auto';
fh.InvertHardcopy = 'off';


text(100, 100, '$\downarrow$','Interpreter','latex', 'Color', 'w', 'FontSize', 100, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
print(fh, 'arrow.png', '-dpng', '-r100');  % Save as PNG at 300 DPI

return