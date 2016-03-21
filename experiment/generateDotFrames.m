function [dotsLall, dotsRall] = generateDotFrames(scr, stm, delay)
%
	% pre-generate stimulus frames for this trial
	% if stimType is delay, this is for a radnom delay period with no motion

	stepDisparity = stm.step.*sum(ismember(stm.dynamics, 'step'));
	rampDisparity = stm.ramp.*sum(ismember(stm.dynamics, 'ramp'));
	
	
	% add in delay frames and divide disparities by two, half for each eye	
	%dotDisparities = [zeros(1, delay) disparities]/2;    
	
	delayFrames = zeros(1, delay);
	% frame dots
	
	[dotsL, dotsR] = mkLeftRightDots(scr, stm, delay + numel(rampDisparity));
	%shiftL.x = repmat(dotDisparities', [1 size(dotsL.x, 2)]);
	%shiftR.x = scr.signRight.*shiftL.x;

	switch direction
		case {'towards', 'away'}
			
			+shiftL.x;
			-shiftR.x;
						
			- shiftL.x;
			+ shiftR.x;
			
		case {'left', 'right'}
			
			directionLR = -1*ismember(stm.directions, 'left') + ...
				ismember(stm.directions, 'right');
			disparities = directionLR*[stepDisparity; rampDisparity];
						
	end
	
	if (strcmp(stm.motiontyp, 'periodic'))
		
	
	dotDisparities = [zeros(1, delay) disparities]/2;
	
	shiftL.x = repmat(dotDisparities', [1 size(dotsL.x, 2)]);
	shiftR.x = scr.signRight.*shiftL.x;
	
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
	