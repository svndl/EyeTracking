function [dotsLall, dotsRall] = generateDotFrames(scr, stm, condition, dynamics, direction, delay)
%
	% pre-generate stimulus frames for this trial
	% if stimType is delay, this is for a radnom delay period with no motion

	


	% dynamics of subsequent frames
	switch dynamics
	
		case 'step'
			disparities = stm.dynamics.step;
		
		case 'ramp'
			disparities = stm.dynamics.ramp;
		
		case 'stepramp'
			disparities = stm.dynamics.stepramp;
		case 'stepramp_same'
			disparities = stm.dynamics.stepramp_same;
		
		otherwise
			error('not a valid experiment type');
	end


	disparities_delay = zeros(1,delay);                     % number of delay frames
	disparities       = [disparities_delay disparities];    % add in delay frames
	disparities       = disparities/2;                      % divide disparities by two, half for each eye	
	
	% frame dots
	
	[dotsL, dotsR] = mkLeftRightDots(scr, stm, condition, length(disparities));
	shiftL.x = repmat(disparities', [1 stm.numDots]);
	shiftR.x = scr.signRight*shiftL.x;

	switch direction
		case 'towards'
			dotsLall.x = dotsL.x + shiftL.x;
			dotsRall.x = dotsR.x - shiftR.x;

			dotsLall.y = dotsL.y;
			dotsRall.y = dotsR.y;
			
		case 'away'
			dotsLall.x = dotsL.x - shiftL.x;
			dotsRall.x = dotsR.x + shiftR.x;
			
		case 'left'
			
			dotsLall.x = dotsL.x - shiftL.x;
			dotsRall.x = dotsR.x - shiftR.x;
			
		case 'right'
			
			dotsLall.x = dotsL.x + shiftL.x;
			dotsRall.x = dotsR.x - shiftR.x;
	end
	
	dotsLall.y = dotsL.y;
	dotsRall.y = dotsR.y;
	
	% crop to circle
	if (~strcmp(condition, 'SingleDot'))
		dotsLall.x = dotsLall.x(:, (dotsLall.x.^2 + (dotsLall.y./scr.Yscale).^2 < stm.stimRadSqPix));
		dotsRall.x = dotsRall.x(:, (dotsRall.x.^2 + (dotsRall.y./scr.Yscale).^2 < stm.stimRadSqPix));
	end
end
	