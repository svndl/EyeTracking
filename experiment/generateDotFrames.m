function [dotsLall, dotsRall] = generateDotFrames(scr, stm, delay)
%
	% pre-generate stimulus frames for this trial
	% if stimType is delay, this is for a radnom delay period with no motion

	stepDisparity = stm.step.*sum(ismember(stm.dynamics, 'step'));
	rampDisparity = stm.ramp.*sum(ismember(stm.dynamics, 'ramp'));
	
	if (ismember(stm.motiontyp, 'periodic'))
		% dot(s) will move back to the start
		rampDisparity = [rampDisparity, rampDisparity(end:-1:1)]
		stepDisparity = [stepDisparity, stepDisparity];
	end

	delayFrames = zeros(1, delay);
	
	
	dir1 = 'towards';
	dir2 = 'away';
	signRightMotion = -1;

	motionInDepth = ismember(stm.directions, dir1) ||
				ismember(stm.directions, dir2);
	
	if (~motionInDepth)
		% linear motion
		dir1 = 'left';
		dir2 = 'right';
		signMotion = 1;
	end
	delayFrames = zeros(1, delay);
	% frame dots
	
	
	directionsSign = -1*ismember(stm.directions, dir1) + ...
		ismember(stm.directions, dir2);
	disparities = directionsSign*[stepDisparity; rampDisparity];

	dotDisparities = [zeros(1, delay) disparities]/2;
	
	[dotsL, dotsR] = mkLeftRightDots(scr, stm, delay + numel(dotDisparities));	
	shiftL.x = repmat(dotDisparities', [1 size(dotsL.x, 2)]);
	shiftR.x = scr.signRight.*shiftL.x*signMotion;
	
	dotsLall.x = dotsL.x + shiftL.x;
	dotsRall.x = dotsR.x + shiftR.x;
	
	dotsLall.y = dotsL.y;
	dotsRall.y = dotsR.y;
	
	% crop to circle
	if (~strcmp(condition, 'SingleDot'))
		dotsLall.x = dotsLall.x(:, (dotsLall.x.^2 + (dotsLall.y./scr.Yscale).^2 < stm.stimRadSqPix));
		dotsRall.x = dotsRall.x(:, (dotsRall.x.^2 + (dotsRall.y./scr.Yscale).^2 < stm.stimRadSqPix));
	end
end
	
