function patch = plotOneEye(timecourse, eyeX, eyeY, legendName, color, stimsetPos)
    muDatax = nanmean(eyeX, 2);
    muDatay = nanmean(eyeY, 2);

    semDatax = nanstd(eyeX, [], 2)/sqrt(size(eyeX, 2));
    semDatay = nanstd(eyeY, [], 2)/sqrt(size(eyeY, 2));
    
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
        legendStr = [legendStr, {'stimset x','stimset y'}];
    end
    legend(legendRef, legendStr{:});
%     xlabel('Time samples');
%     ylabel('Degrees per second');
    patch = h1.patch;
end