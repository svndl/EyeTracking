function [timecourse, pos, vel] = convertEyelinkData(trialData, ipd, trialDuration)

%    vals = {'time', 'Lx', 'Ly', 'Rx', 'Ry', 'LVx', 'LVy', 'RVx', 'RVy'};
%    data = { 1      2     3     4     5     6       7      8      9}
    nTrials = numel(trialData);
    xData = zeros(nTrials, 1);
    yData = cell(nTrials, 1);
    
    %resample trial data
    for nt = 1:nTrials
        % use duration for the X grid
        xData(nt) = numel(trialData{nt}(:, 1));
        yData{nt} = trialData{nt}(:, 2:end);
    end;
    
    elInfo = loadEyelinkInfo;
    timepoints = elInfo.sampleRate*trialDuration;
    
    % resample each trial data to trialDuration 
    [timecourse, trials] = resampleData(xData, yData, timepoints);
    
    %trialsAvg = mean(trials, 3);
    %dataCm = trialsAvg.*elInfo.href2cm;
    
    ipd_href = elInfo.href2cm*ipd; 
    [degL, degR] = href2angle(trials(:, 1:2, :), trials(:, 3:4, :), ipd_href);
    
    % shift all to (0, 0)
    pos.L = degL - repmat(degL(1, :, :), [size(degL, 1) 1 1]);
    pos.R = degR - repmat(degR(1, :, :), [size(degR, 1) 1 1]);
    
    % average
    pos.Lavg = mean(pos.L, 3);
    pos.Ravg = mean(pos.R, 3);
    
    pos.Vergence = pos.Lavg - pos.Ravg;
    pos.Version = mean(cat(3, pos.Lavg, pos.Ravg), 3);
    
    vel.L = trials(:, 5:6, :);     
    vel.R = trials(:, 7:8, :);
    
    vel.Lavg = mean(vel.L, 3);
    vel.Ravg = mean(vel.R, 3);
    
    %binocular angular velocity
    vel.Vergence = vel.Lavg - vel.Ravg;
    vel.Version = mean(cat(3, vel.Lavg, vel.Ravg), 3);
    %generatePreditions(trialData);
end
