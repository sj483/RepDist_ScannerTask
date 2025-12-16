

for ii = 0:100
    textX = int2str(ii);

    % Create a new figure
    fig = figure;

 % Set the axis limits to 830x830
    axis([0 200 0 200]);
    % Set the aspect ratio to ensure equal lengths
    pbaspect([1 1 1]);
    set(gca, 'Color', [0.5,0.5,0.5]); % Set background to grey
    set(gca, 'XColor', 'none', 'YColor', 'none'); % Remove axis lines


    % % Expand axis to fill figure
    set(gca, 'Position', [0 0 1 1]);
    % 
    % % Set figure size to be square
    fig.Units = 'pixels';
    fig.Position(3:4) = [200 200]; % Make it nicely square (larger than 830 to allow room)


    fig.Units = 'inches';
    fig.Position = [0 0 2 2];  % 2 in × 2 in
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 2 2];
    % Set paper mode to auto so it saves as it appears
    fig.PaperPositionMode = 'auto';
    fig.InvertHardcopy = 'off';


    %pbaspect([1 1 1]);

    % Add text
    text(100, 110, textX, 'Color', 'w', 'FontSize', 139, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

    % Save as JPEG or PNG
    name = sprintf('%03d%i', ii);
    print(fig, [name, '.png'], '-dpng', '-r100'); %100 DPI
end
% 
% for ii = 100
%     textX = int2str(ii);
% 
%     % Create a new figure
%     fig = figure;
% 
%  % Set the axis limits to 830x830
%     axis([0 200 0 200]);
%     % Set the aspect ratio to ensure equal lengths
%     pbaspect([1 1 1]);
%     set(gca, 'Color', [0.5,0.5,0.5]); % Set background to grey
%     set(gca, 'XColor', 'none', 'YColor', 'none'); % Remove axis lines
% 
% 
%     % % Expand axis to fill figure
%     set(gca, 'Position', [0 0 1 1]);
%     % 
%     % % Set figure size to be square
%     fig.Units = 'pixels';
%     fig.Position(3:4) = [200 200]; % Make it nicely square (larger than 830 to allow room)
% 
% 
%     fig.Units = 'inches';
%     fig.Position = [0 0 2 2];  % 2 in × 2 in
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0 0 2 2];
%     % Set paper mode to auto so it saves as it appears
%     fig.PaperPositionMode = 'auto';
%     fig.InvertHardcopy = 'off';
% 
% 
%     %pbaspect([1 1 1]);
% 
%     % Add text
%     text(96, 110, textX, 'Color', 'w', 'FontSize', 93, ...
%         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
% 
%     % Save as JPEG or PNG
%     name = sprintf('%03d%i', ii);
%     print(fig, [name, '.png'], '-dpng', '-r100');  % Save as PNG at 300 DPI
% 
% end
% 


