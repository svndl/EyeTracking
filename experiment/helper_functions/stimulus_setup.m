function stim_session = stimulus_setup(stimset, videoMode)
	
	%%SCREEN 

	if stimset.dispArcmin < videoMode.pix2arcmin; 
		warning('disparity requested is less than 1 pixel'); 
	end


	%%  STIMULUS

	stim_session.dispPix         = stimset.dispArcmin/videoMode.pix2arcmin;
	
	% end full disparity of ramp in degrees/pixels relative to start position
	rampEndDispDeg      = 2*(stimset.rampSpeedDegSec*stimset.cycleSec);     
	stim_session.rampEndDispPix  = (60*rampEndDispDeg)/videoMode.pix2arcmin;
	
	stim_session.stimRadPix      = round((60*stimset.stimRadDeg)/videoMode.pix2arcmin);    
	stim_session.stimRadSqPix    = stim_session.stimRadPix^2;                            
	stim_session.dotSizePix      = (stimset.dotSizeDeg*60)/videoMode.pix2arcmin;         

	% full x field of dots before circle crop	
	
	stim_session.xmax            = 4*max([stim_session.stimRadPix stim_session.rampEndDispPix]);   
	stim_session.ymax            = stim_session.xmax;                                  
	
	stim_session.numDots = round( stimset.dotDensity*(  stim_session.xmax*(videoMode.pix2arcmin/60)*...
		stim_session.ymax*(videoMode.pix2arcmin/60) ) );


	%%  TIMING
	% note: dot drawing is done frame-by-frame rather than using PTB WaitSecs,
	% this seems to provide better precision, although time is still not
	% perfect (a few frames tend to be dropped)

	% duration to hold dots on screen	
	stim_session.dotUpdateSec    = 1/stimset.dotUpdateHz;                                
	% number of frames to hold dots on screen	
	stim_session.dotRepeats		= round(videoMode.frameRate/stimset.dotUpdateHz);
	% number of times the stimulus is updated in a rap cycle
	stim_session.numUpdates      = round(stimset.dotUpdateHz*stimset.cycleSec);
	% number of times the stimulus is updated in a preclue
	stim_session.preludeUpdates  = round(stimset.dotUpdateHz*stimset.preludeSec);
	
	preludeDisparity =  zeros(1, stim_session.preludeUpdates);
	rampDisparity = linspace(stim_session.rampEndDispPix/stim_session.numUpdates, ...
		stim_session.rampEndDispPix, stim_session.numUpdates);
	
	% set up step, ramp, stepramp updates
	stim_session.dynamics.step     = [ preludeDisparity repmat(stim_session.dispPix, 1, stim_session.numUpdates)];   
	stim_session.dynamics.ramp     = [ preludeDisparity rampDisparity];
	stim_session.dynamics.stepramp = [ preludeDisparity stim_session.dispPix - linspace(0, stim_session.rampEndDispPix - ...
		(stim_session.rampEndDispPix/stim_session.numUpdates), stim_session.numUpdates)];


	% conditions should not don't exceed calibration area
	isTooBigForRamp = max(stim_session.dynamics.ramp/2) > videoMode.caliRadiusPixX;
	isTooBigForStep = max(stim_session.dynamics.step/2) > videoMode.caliRadiusPixX;
	isTooBigForStepRamp = max(stim_session.dynamics.stepramp/2) > videoMode.caliRadiusPixX;


	if(isTooBigForRamp || isTooBigForStep || isTooBigForStepRamp)
		warning('need to increase calibration area in order to run this condition');
	end

	%%  FIXATION

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

