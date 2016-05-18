function [timecourse, pos, vel] = processTrialData(trialData, ipd, trialDuration)

%    vals = {'time', 'Lx', 'Ly', 'Rx', 'Ry'};
%    data = { 1      2     3     4     5   }
    nTrials = numel(trialData);
    xData = zeros(nTrials, 1);
    yData = cell(nTrials, 1);
    %resample trial data
    for nt = 1:nTrials
        % use duration for the X grid
        xData(nt) = numel(trialData{nt}.data(:, 1));
        yData{nt} = trialData{nt}.data(:, 2:5);
    end;
    
    elInfo = loadEyelinkInfo;
    timepoints = elInfo.sampleRate*trialDuration;
    
    % resample each trial data to trialDuration 
    [timecourse, trials] = resampleData(xData, yData, timepoints);
    
    trialsAvg = mean(trials, 3);
    dataCm = trialsAvg.*elInfo.href2cm;
    
    pos.L = screen2deg(dataCm(:, 1:2), elInfo, ipd);
    pos.R = screen2deg(dataCm(:, 3:4), elInfo, -ipd);

    pos.Vergence = pos.L - pos.R;
    pos.Version = mean(cat(3, pos.L, pos.R), 3);
    
    vel.L = computeVelocity(pos.L, elInfo.sampleRate);     
    vel.R = computeVelocity(pos.R, elInfo.sampleRate);
    
    %binocular angular velocity
    vel.Vergence = computeVelocity(pos.Vergence, elInfo.sampleRate);
    vel.Version = computeVelocity(pos.Version, elInfo.sampleRate);
    %generatePreditions(trialData);
end
