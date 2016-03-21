function [dotsL, dotsR] = generateTrial(stimset, videoMode)

	%%SCREEN 

	if stimset.dispArcmin < videoMode.pix2arcmin; 
		warning('disparity requested is less than 1 pixel'); 
	end


	%%  degrees and arcmin to pixels	
	stim_session.dispPix         = stimset.dispArcmin/videoMode.pix2arcmin;
	stim_session.stimRadPix      = round((60*stimset.stimRadDeg)/videoMode.pix2arcmin);    
	stim_session.stimRadSqPix    = stim_session.stimRadPix^2;                            
	stim_session.dotSizePix      = (stimset.dotSizeDeg*60)/videoMode.pix2arcmin;         

	%% timing
	
	stim_session.dotUpdateSec    = 1/stimset.dotUpdateHz;                                
	stim_session.dotRepeats		 = round(videoMode.frameRate/stimset.dotUpdateHz);
	stim_session.numUpdates      = round(stimset.dotUpdateHz*stimset.cycleSec);
	stim_session.preludeUpdates  = round(stimset.dotUpdateHz*stimset.preludeSec);
	
	
	
	
	%% nothing happens
	preludeDisparity =  zeros(1, stim_session.preludeUpdates);
	
	
	%% where dot(s) will end up
	
	rampEndDispDeg      = 2*(stimset.rampSpeedDegSec*stimset.cycleSec);     
	stim_session.rampEndDispPix  = (60*rampEndDispDeg)/videoMode.pix2arcmin;
	

	%% full x field of dots before circle crop	
	
	stim_session.xmax            = 4*max([stim_session.stimRadPix stim_session.rampEndDispPix]);   
	stim_session.ymax            = stim_session.xmax;                                  	
	stim_session.numDots = round( stimset.dotDensity*(  stim_session.xmax*(videoMode.pix2arcmin/60)*...
		stim_session.ymax*(videoMode.pix2arcmin/60) ) );


	
	step.direction
	ramp.direction
	switch stimset.dynamics
		
		case 'step'
			trialDynamics = repmat(stim_session.dispPix, 1, stim_session.numUpdates);
		case 'ramp'
			trialDynamics = linspace(stim_session.rampEndDispPix/stim_session.numUpdates, ...
				stim_session.rampEndDispPix, stim_session.numUpdates);			
		case 'stepramp'	
			trialDynamics = linspace(0, stim_session.rampEndDispPix - ...
				(stim_session.rampEndDispPix/stim_session.numUpdates), stim_session.numUpdates);
					%same stepramp trialDynamics = [stim_session.dispPix + steprampDisparity];
					%opposite stepramp trialDynamics = [stim_session.dispPix - steprampDisparity];
		otherwise
			
	end
	
	switch stimset.direction
		
		
	end
	
	
	
	
	switch stimset.motionType
		
		
	end
	

	
	disparities_delay = zeros(1,delay);                     % number of delay frames
	disparities       = [disparities_delay disparities];    % add in delay frames
	disparities       = disparities/2;                      % divide disparities by two, half for each eye

	% generate all frames
	for x = 1:length(disparities)
	
	
	% new dot pattern at each update for CDOT and first half of Mixed Dots
	switch condition
		
		case 'CDOT'
			
			[dotsLE,dotsRE] = stimulus_make_left_right_dots(scr,stm,condition);
			
		case {'Mixed','MixedIncons','MixedCons'}
			
			[dots] = stimulus_make_random_dots(stm.xmax,stm.ymax,round(stm.numDots/2));
			
			dotsLE(:,1:round(stm.numDots/2))      = dots;
			dotsRE(:,1:round(stm.numDots/2))      = dots;
						
	end
	
	% generate LE and RE shifts for this frame
	shiftLE = [repmat(disparities(x), 1, size(dotsLE,2)) ; zeros(1,size(dotsLE,2))];
	shiftRE = [scr.signRight*repmat(disparities(x),1,size(dotsRE,2)) ; zeros(1,size(dotsRE,2))];
	
	% reverse uncorrelated dots for the Mixed, Inconsistent condition
	if strcmp(condition,'MixedIncons')
		
		shiftLE(:,round(stm.numDots/2)+1:end) = -shiftLE(:,round(stm.numDots/2)+1:end);
		shiftRE(:,round(stm.numDots/2)+1:end) = -shiftRE(:,round(stm.numDots/2)+1:end);
		
	end
	
	switch direction
		
		case 'towards'
			
			dotsLEall = dotsLE + shiftLE;
			dotsREall = dotsRE - shiftRE;
			
		case 'away'
			
			dotsLEall = dotsLE - shiftLE;
			dotsREall = dotsRE + shiftRE;
			
		case 'left'
			
			dotsLEall = dotsLE - shiftLE;
			dotsREall = dotsRE - shiftRE;
			
		case 'right'
			
			dotsLEall = dotsLE + shiftLE;
			dotsREall = dotsRE - shiftRE;			
	end
	
			
	if ~strcmp(condition,'SingleDot')
		% crop to circle
		dotsLEcr(x, :) = dotsLEall(:,(dotsLEall(1,:).^2 + (dotsLEall(2,:)./scr.Yscale).^2 < stm.stimRadSqPix));
		dotsREcr(x, :) = dotsREall(:,(dotsREall(1,:).^2 + (dotsREall(2,:)./scr.Yscale).^2 < stm.stimRadSqPix));
	else
		dotsLEcr(x, :) = dotsLEall;
		dotsREcr(x, :) = dotsREall;
	end
	
	
	
	end
	
	%base disparity
	stim_session.disparity = [preludeDisparity trialDynamics];
	
	
	%% linear motion
	% set up step, ramp, stepramp updates
	stim_session.dynamics.step     = [ preludeDisparity ];   
	stim_session.dynamics.ramp     = [ preludeDisparity rampDisparity];
	
	
	
	%opposite direction ramp
	
	%same direction ramp
	stim_session.dynamics.stepramp_same = [ preludeDisparity stim_session.dispPix + steprampDisparity];

	% conditions should not don't exceed calibration area
	isTooBigForRamp = max(stim_session.dynamics.ramp/2) > videoMode.caliRadiusPixX;
	isTooBigForStep = max(stim_session.dynamics.step/2) > videoMode.caliRadiusPixX;
	isTooBigForStepRamp = max(stim_session.dynamics.stepramp/2) > videoMode.caliRadiusPixX;

	
	if(isTooBigForRamp || isTooBigForStep || isTooBigForStepRamp)
		warning('need to increase calibration area in order to run this condition');
	end
	
	
	%% fixation
	stim_session.fixationRadiusDeg = 1;
	stim_session.fixationRadiusPix = (60*stim_session.fixationRadiusDeg)/videoMode.pix2arcmin;
	stim_session.fixationRadiusSqPix = stim_session.fixationRadiusPix^2;

	stim_session.fixationDotRadiusDeg = 0.125;
	stim_session.fixationDotRadiusPix = (60*stim_session.fixationDotRadiusDeg)/videoMode.pix2arcmin;

	stim_session.fixationRadiusYPix = stim_session.fixationRadiusPix*videoMode.Yscale;
	stim_session.fixationRadiusXPix = stim_session.fixationRadiusPix;


	%%  TRIAL STRUCTURE 

	stim_session.trials.condition        = {};	
	stim_session.trials.dynamics         = {};
	stim_session.trials.direction        = {};
	stim_session.trials.repeat           = [];	

	for c = 1:length(stimset.conditions)
    
		for d = 1:length(stimset.dynamics)
        
			for n = 1:length(stimset.directions)
            
				for r = 1:stimset.cond_repeats
                
					stim_session.trials.condition    = [stim_session.trials.condition ; stimset.conditions{c}];
					stim_session.trials.dynamics     = [stim_session.trials.dynamics ; stimset.dynamics{d}];
					stim_session.trials.direction    = [stim_session.trials.direction ; stimset.directions{n}];
					stim_session.trials.repeat       = [stim_session.trials.repeat ; r];
                
				end
			end     
		end
	end

	% randomize trial order
	stim_session.trials.trialnum = randperm(length(stim_session.trials.condition));

	% emptry response arrays
	stim_session.trials.resp         = cell(1, length(stim_session.trials.condition));
	stim_session.trials.respCode     = NaN*ones(1, length(stim_session.trials.condition));
	stim_session.trials.isCorrect    = zeros(1, length(stim_session.trials.condition));

	% generate random delay period for each trial
	stim_session.trials.delayTimeSec = randi([250 750], 1, length(stim_session.trials.condition))./1000;
	stim_session.trials.delayUpdates = round(stimset.dotUpdateHz*stim_session.trials.delayTimeSec);


	%% SOUND %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	cf = 1000;                  % carrier frequency (Hz)
	sf = 22050;                 % sample frequency (Hz)
	d = 0.1;                    % duration (s)
	n = sf * d;                 % number of samples
	s = (1:n) / sf;             % sound data preparation
	s = sin(2 * pi * cf * s);   % sinusoidal modulation
	stim_session.sound.s = s;
	stim_session.sound.sf = sf;

	cf = 2000;                  % carrier frequency (Hz)
	sf = 22050;                 % sample frequency (Hz)
	d = 0.1;                    % duration (s)
	n = sf * d;                 % number of samples
	s = (1:n) / sf;             % sound data preparation
	s = sin(2 * pi * cf * s);   % sinusoidal modulation
	stim_session.sound.sFeedback = s;
	stim_session.sound.sfFeedback = sf;










end