function [timecourse, pos, vel] = convertEyelinkData(trialData, ipd, trialDuration, nanThresh)

%    vals = {'time', 'Lx', 'Ly', 'Rx', 'Ry', 'LVx', 'LVy', 'RVx', 'RVy'};
%    data = { 1      2     3     4     5     6       7      8      9}
    nTrials = numel(trialData);
    %xData = zeros(nTrials, 1);
    yData = cell(nTrials, 1);
    
    %resample trial data
    for nt = 1:nTrials
        % use duration for the X grid
        %xData(nt) = numel(trialData{nt}(:, 1));
        yData{nt} = trialData{nt}(:, 2:end);
    end;
    elInfo = loadEyelinkInfo;
    elInfo.sampleRate = 250;
    timepoints = elInfo.sampleRate*trialDuration;
    upsampleRate = elInfo.resampleRate/elInfo.sampleRate;
    % resample each trial data to trialDuration 
    [timecourse, trials, trialsOrig] = resampleData(yData, timepoints, upsampleRate, nanThresh);
    
    %trialsAvg = mean(trials, 3);
    %dataCm = trialsAvg.*elInfo.href2cm;
    
    ipd_href = elInfo.href2cm*ipd; 
    [degL, degR] = href2angle(trials(:, 1:2, :), trials(:, 3:4, :), ipd_href);
    
    % shift all to (0, 0) and flip the signs
    pos.L = -startAtZero(degL);
    pos.R = -startAtZero(degR);
           
    vel.L = -trials(:, 5:6, :);     
    vel.R = -trials(:, 7:8, :);
    
    %% save original trials
    %[degL_orig, degR_orig] = href2angle(trialsOrig(:, 1:2, :), trialsOrig(:, 3:4, :), ipd_href);
    % pos.orig.L = -startAtZero(degL_orig);
    % pos.orig.R = -startAtZero(degR_orig);
end
