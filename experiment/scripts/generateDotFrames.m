function [dotsLall, dotsRall] = generateDotFrames(scr, stm, delay)
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
	
	dir1 = 'towards';
	dir2 = 'away';
    signMotion = -1;

	motionInDepth = sum(ismember(stm.directions, dir1) + ...
				ismember(stm.directions, dir2));
            
            
    if (~motionInDepth)
		% linear motion
		dir1 = 'left';
		dir2 = 'right';
		signMotion = 1;
    end
    
	delayFrames = zeros(1, delay);

	directionsSign = -1*ismember(stm.directions, dir1) + ... 
		ismember(stm.directions, dir2);
    
	disparities = directionsSign*[stepDisparity; rampDisparity];

	dotDisparities = [delayFrames, disparities]/2;
	
	[dotsL, dotsR] = mkLeftRightDots(scr, stm, numel(dotDisparities));	
	shiftL.x = repmat(dotDisparities', [1 size(dotsL.x, 2)]);
	shiftR.x = scr.signRight.*shiftL.x*signMotion;
	
	dotsLall.x = dotsL.x + shiftL.x;
	dotsRall.x = dotsR.x + shiftR.x;
	
	dotsLall.y = dotsL.y;
	dotsRall.y = dotsR.y;
	
	% crop to circle
	if (~strcmp(stm.condition, 'SingleDot'))
		dotsLall.x = dotsLall.x(:, (dotsLall.x.^2 + (dotsLall.y./scr.Yscale).^2 < stm.stimRadSqPix));
		dotsRall.x = dotsRall.x(:, (dotsRall.x.^2 + (dotsRall.y./scr.Yscale).^2 < stm.stimRadSqPix));
	end
end
	
