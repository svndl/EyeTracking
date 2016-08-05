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
    pos.L = startAtZero(degL);
    pos.R = startAtZero(degR);
        
    pos.Vergence = mean(pos.L, 3) - mean(pos.R, 3);
    pos.Version = mean(cat(3, pos.L, pos.R), 3);
    
    vel.L = trials(:, 5:6, :);     
    vel.R = trials(:, 7:8, :);
        
    %binocular angular velocity
    vel.Vergence = mean(vel.L, 3) - mean(vel.R, 3);
    vel.Version = mean(cat(3, vel.L, vel.R), 3);
    %generatePreditions(trialData);
end
