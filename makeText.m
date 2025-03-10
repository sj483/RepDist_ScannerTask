function [txtTexture] = makeText(textX, globals)
    
    % Create a new figure
    figure;
    
    % Set the axis limits to 830x830
    axis([0 830 0 830]);
    
    % Set the aspect ratio to ensure equal lengths
    pbaspect([1 1 1]);
    set(gca, 'Color', 'k'); % Set background to black
    set(gca, 'XColor', 'none', 'YColor', 'none'); % Remove axis lines
    
    % Expand axis to fill figure
    set(gca, 'Position', [0 0 1 1]);

    % Add the text "5" to the center of the axis
    if strcmp(textX,"arrow")
        text(415, 415, '$\downarrow$','Interpreter','latex', 'Color', 'w', 'FontSize', 200, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    else     
        text(415, 415, textX, 'Color', 'w', 'FontSize', 200, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end
    
    fig = gcf;
    % Prevent additional plotting changes
    hold on;
    
       %saveas(fig, 'text.png'); % Save as a PNG file
    exportgraphics(fig,'text.png','ContentType','image','Resolution', 300, 'BackgroundColor', 'black')
    textImg = imread('text.png');
    hold off
    close(fig); %this doesnt to work on last go ??
    imshow(textImg)
    %make image into texture
    txtTexture = Screen('MakeTexture', globals.window, textImg);

return