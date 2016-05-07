function vAngle = computeVelocity(trialData)
% take eye position data and convert to velocity

    % sgolay filter design for differentiation
    % Order of polynomial fit    
    N = 3;                
    % Window length    
    F = 101;               
    % Calculate S-G coefficients    
    [~, g] = sgolay(N, F);     
    spacing = 1/trialData.el.sampleRate; % temporal spacing between samples

    % monocular angular velocity
    vAngle.Lx = to_velocity(trialData.LExAng, spacing, g, F);
    vAngle.Ly = to_velocity(trialData.LEyAng, spacing, g, F);
    
    vAngle.Rx = to_velocity(trialData.RExAng, spacing, g, F);
    vAngle.Ry = to_velocity(trialData.REyAng, spacing, g, F);
    
    % binocular angular velocity
    vAngle.vergence = to_velocity(trialData.trials.vergenceH{x},spacing,g,F);
    vAngle.version = to_velocity(trialData.trials.versionH{x},spacing,g,F);
    
    % predictions (just horizontal)
%     predictionLEVelo{x} = trialData.predictionLEVelo{x};
%     predictionREVelo{x} = trialData.predictionREVelo{x};
end

function velo = to_velocity(x, spacing, g, F)
% convert position to velocity using sgolay filter
% velo = gradient(x,spacing); %gradient filter -- too noisy!
    HalfWindowF  = (F + 1)/2 - 1; % half filter width
    
    SG1 = zeros(numel(length(x) - 2*HalfWindowF));
    
    % 1st differential
    for n = HalfWindowF:length(x) - HalfWindowF - 1
        SG1(n) = dot(g(:, 2), x(n - HalfWindowF:n + HalfWindowF));
    end

    % Turn differential into derivative, pad with NaNs
    velo = [(SG1/spacing) NaN*ones(1, HalfWindowF + 1) - HalfWindowF]';
end