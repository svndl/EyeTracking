function patch = plotOneEye1D(timecourse, eyeData, legendName, color, stimsetPos)
    muData = mean(eyeData, 2);

    semData = std(eyeData, [], 2)/sqrt(size(eyeData, 2));
    
    h1 = shadedErrorBar(timecourse, muData, semData, {['-' color], 'LineWidth', 2}); hold on
    legendRef = [h1.patch];
    legendStr =  {legendName};
    if (~(isempty(stimsetPos)))
    
        p1 = plot(timecourse(1:25:end), -stimsetPos(1:25:end), [':' color], ...
            'LineWidth', 1.5, 'MarkerSize', 5, 'Marker', '+'); hold on;
        legendRef = [legendRef p1];
        legendStr = [legendStr {'stimset trajectory'}];
    end
    legend(legendRef, legendStr{:});
    xlabel('Time samples');
    ylabel('Degrees per second');
    patch = h1.patch;
end
