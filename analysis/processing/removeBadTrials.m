function plotAllTrials(varargin)
    close all;
    dirData = setPath;
    dataDir = dirData.data;
       
    if(~nargin)
        sessionPath = uigetdir(dataDir);
    else
        sessionPath = varargin{1};
    end
    data = loadSession(sessionPath);
    cndOKIdx = ~cellfun(@isempty, data);
    data = data(cndOKIdx);
    
    % average over 10% 
    smoothOver = 0.1;    
    % for each condition plot all trials
    for c = 1: sum(cndOKIdx)
        figure;
        figureName = [data{c}.info.name ' ' data{c}.info.dynamics{:} ...
            ' ' data{c}.info.direction{:}];
        
        set(gcf,'name', figureName,'numbertitle','off');
        
        lx = squeeze(data{c}.pos.L(:, 1, :));
        ly = squeeze(data{c}.pos.L(:, 2, :));
        rx = squeeze(data{c}.pos.R(:, 1, :));
        ry = squeeze(data{c}.pos.R(:, 2, :));
        subplot(4, 1, 1);
        title('Left eye X trials')
        plot(smoothData(lx, smoothOver));
        subplot(4, 1, 2);
        title('Left eye Y trials')
        plot(smoothData(ly, smoothOver));
        subplot(4, 1, 3);
        title('Right eye X trials')
        plot(smoothData(rx, smoothOver));
        subplot(4, 1, 4);
        title('Right eye Y trials')        
        plot(smoothData(ry, smoothOver));
        
        saveas(gcf, fullfile(sessionPath, figureName), 'fig')
        
        close gcf;
    end   
end

function out = smoothData(inputData, smoothLen)

 out = cell2mat(cellfun(@(x) smooth(x, smoothLen, 'loess'), ...
     num2cell(inputData, 1), 'UniformOutput', false));
end