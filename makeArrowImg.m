
% Create a new figure
fig = figure;

% Set the axis limits to 830x830
axis([0 830 0 830]);

% Set the aspect ratio to ensure equal lengths
pbaspect([1 1 1]);
set(gca, 'Color', [0.5,0.5,0.5]); % Set background to black
set(gca, 'XColor', 'none', 'YColor', 'none'); % Remove axis lines

% Expand axis to fill figure
set(gca, 'Position', [0 0 1 1]);

% Set figure size to be square
fig.Units = 'pixels';
fig.Position(3:4) = [850 850]; % Make it nicely square (larger than 830 to allow room)

% Set paper mode to auto so it saves as it appears
fig.PaperPositionMode = 'auto';
fig.InvertHardcopy = 'off';

text(415, 415, '$\downarrow$','Interpreter','latex', 'Color', 'w', 'FontSize', 400, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
print(fig, 'arrow.png', '-dpng', '-r300');  % Save as PNG at 300 DPI
