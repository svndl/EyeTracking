function [timecourse, pos, vel] = processTrialData(trialData, ipd, trialDuration)

%    vals = {'time', 'Lx', 'Ly', 'Rx', 'Ry', 'meta', 'qual'};
%    data = { 1      2     3     4     5     6       7}
    nTrials = numel(trialData);
    xData = cell(nTrials, 1);
    yData = cell(nTrials, 1);
    %resam[ple trial data
    for nt = 1:nTrials
        xData{nt} = trialData{nt}.data(:, 1);
        yData{nt} = trialData{nt}.data(:, 2:5);
    end;
    
    elInfo = loadEyelinkInfo;
    timepoints = elInfo.sampleRate*trialDuration;
    [timecourse, trials] = resampleData(xData, yData, timepoints);
    
    trialsAvg = nanmean(trials, 3);
    dataCm = trialsAvg.*elInfo.href2cm;
    
    pos.L = screen2deg(dataCm(:, 1:2), elInfo, ipd);
    pos.R = screen2deg(dataCm(:, 3:4), elInfo, -ipd);

    pos.Vergence = pos.L - pos.R;
    pos.Version = nanmean(cat(3, pos.L, pos.R), 3);
    
    vel.L = computeVelocity(pos.L, elInfo.sampleRate);     
    vel.R = computeVelocity(pos.R, elInfo.sampleRate);
    
    %binocular angular velocity
    vel.Vergence = computeVelocity(pos.Vergence, elInfo.sampleRate);
    vel.Version = computeVelocity(pos.Version, elInfo.sampleRate);
    %generatePreditions(trialData);
end
