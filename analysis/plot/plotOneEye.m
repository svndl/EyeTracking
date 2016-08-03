function patch = plotOneEye(timecourse, eyeX, eyeY, legendName, color, stimsetPos)
    muDatax = mean(eyeX, 2);
    muDatay = mean(eyeY, 2);

    semDatax = std(eyeX, [], 2)/sqrt(size(eyeX, 2));
    semDatay = std(eyeY, [], 2)/sqrt(size(eyeY, 2));
    
    [xColor, yColor] = convertColor(color);

    h1 = shadedErrorBar(timecourse, muDatax, semDatax, {'-', 'color',  xColor, 'LineWidth', 2}); hold on
    h2 = shadedErrorBar(timecourse, muDatay, semDatay, {'-', 'color',  yColor, 'LineWidth', 2}); hold on
    legendRef = [h1.patch, h2.patch];
    legendStr =  {[ legendName ' x'], [legendName ' y']};
    if (~(isempty(stimsetPos)))
        stimPosx = stimsetPos.x;
        stimPosy = stimsetPos.y; 
    
        p1 = plot(timecourse(1:25:end), -stimPosx(1:25:end), ':', 'color', xColor, ...
            'LineWidth', 1.5, 'MarkerSize', 5, 'Marker', '+'); hold on;
        p2 = plot(timecourse(1:25:end), -stimPosy(1:25:end), ':', 'color', yColor, ...
            'LineWidth', 1.5, 'MarkerSize', 5, 'Marker', '+'); hold on;
        legendRef = [legendRef p1 p2];
        legendStr = {legendStr{:}, 'stimset x','stimset y'};
    end
    legend(legendRef, legendStr{:});
    xlabel('Time samples');
    ylabel('Degrees per second');
    patch = h1.patch;
end
function [xc, yc] = convertColor(inputColor)
    switch (inputColor)
        case 'r'
            xc = [ 240 20 20 ];
            yc = [ 200 50 150 ];
        case 'b'
            xc = [ 20 20 240 ];
            yc = [ 0 174 239 ];
        case 'k'
            xc = [ 170 120 140 ];
            yc = [ 125 120 125 ];
        case 'g'
            xc = [ 106 225 106 ];
            yc = [ 76 225 74 ];
    end
    xc = xc/255;
    yc = yc/255;
end