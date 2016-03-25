function dotDisparities = mkDotShift(stm)
%
	% pre-generate stimulus frames for this trial
	% if stimType is delay, this is for a radnom delay period with no motion
    
    hasStep = sum(ismember(stm.dynamics, 'step'));
    hasRamp = sum(ismember(stm.dynamics, 'ramp'));
    
	sd = stm.step.*hasStep;
	rd = stm.ramp.*hasRamp;
    pd = stm.prelude;

    stepDisparity = [];
    rampDisparity= [];
    
    if (hasStep)
        stepDisparity = [pd, sd];
    end
    if (hasRamp)
        rampDisparity = [pd, rd];
    end
	    
	delayFrames = [];
    
	disparities = stepDisparity + signDir(stm)*rampDisparity;
	dotDisparities = [delayFrames, disparities]/2;	
end

function  sd = signDir(stm)

    sd = - 1;
    if (numel(unique(stm.directions)) > 1)
        sd = 1;
    end     
end
