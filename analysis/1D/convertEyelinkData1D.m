function [timecourse, pos, vel] = convertEyelinkData1D(trialData, ipd, trialDuration)

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
    [degL, degR] = href2angle1D(trials(:, 1:2, :), trials(:, 3:4, :), ipd_href);
    
    % shift all to (0, 0)
    pos.L = degL - repmat(degL(1, :), [size(degL, 1) 1]);
    pos.R = degR - repmat(degR(1, :), [size(degR, 1) 1]);
    
    % average
    pos.Lavg = mean(pos.L, 2);
    pos.Ravg = mean(pos.R, 2);
    
    pos.Vergence = pos.Lavg - pos.Ravg;
    pos.Version = mean(cat(2, pos.Lavg, pos.Ravg), 2);
    
    vel.L = squeeze(sqrt(trials(:, 5, :).^2 + trials(:, 6, :).^2));     
    vel.R = squeeze(sqrt(trials(:, 7, :).^2 + trials(:, 8, :).^2));
    
    vel.Lavg = mean(vel.L, 2);
    vel.Ravg = mean(vel.R, 2);
    
    %binocular angular velocity
    vel.Vergence = vel.Lavg - vel.Ravg;
    vel.Version = mean(cat(2, vel.Lavg, vel.Ravg), 2);
    %generatePreditions(trialData);
end
