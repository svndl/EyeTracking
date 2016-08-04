function dotDisparities = mkDotShift(stm)
%
	% pre-generate stimulus frames for this trial
	% if stimType is delay, this is for a radnom delay period with no motion
    
    hasStep = sum(ismember(stm.dynamics, 'step'));
    hasRamp = sum(ismember(stm.dynamics, 'ramp'));
    
	sd = stm.step.*hasStep;
	rd = stm.ramp.*hasRamp;
    pd = stm.prelude;

    stepDisparity = 0;
    rampDisparity = 0;
    
    if (hasStep)
        stepDisparity = [pd, sd];
    end
    if (hasRamp)
        rampDisparity = [pd, rd];
    end
	    
	delayFrames = [];
    
	disparities = stepDisparity + signDir(stm)*rampDisparity;
	dotDisparities = [delayFrames, disparities];	
end

function  sd = signDir(stm)

    sd = 1;
    % if we have a combination of left+right directions  
    if (numel(unique(stm.direction)) == 2 && numel(stm.direction )== 2)
        sd = -1;
    end     
end
