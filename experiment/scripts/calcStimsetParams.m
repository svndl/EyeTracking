function params = calcStimsetParams(stimset, videoMode)
	
	%%SCREEN 
    
    if stimset.dispArcmin < videoMode.pix2arcmin; 
		warning('disparity requested is less than 1 pixel');
    end

    params = stimset;
	%%  STIMULUS	
	params.dispPix = stimset.dispArcmin/videoMode.pix2arcmin;
    
    % deal with periodic motion
    
	if (~stimset.isPeriodic)
        rampEndDispDeg      = 2*(stimset.rampSpeedDegSec*stimset.cycleSec);
        params.numUpdates = round(stimset.dotUpdateHz*stimset.cycleSec);
    else
        rampEndDispDeg = stimset.rampSpeedDegSec;
        params.numUpdates = round(0.5*stimset.dotUpdateHz);        
    end
    
    params.rampEndDispPix  = (60*rampEndDispDeg)/videoMode.pix2arcmin;
	
	params.stimRadPix      = round((60*stimset.stimRadDeg)/videoMode.pix2arcmin);    
	params.stimRadSqPix    = params.stimRadPix^2;                            
	params.dotSizePix      = (stimset.dotSizeDeg*60)/videoMode.pix2arcmin;         

	% full x field of dots before circle crop	
	
	params.xmax            = 4*max([params.stimRadPix params.rampEndDispPix]);   
	params.ymax            = params.xmax;                                  
	
	params.numDots = round( stimset.dotDensity*(  params.xmax*(videoMode.pix2arcmin/60)*...
		params.ymax*(videoMode.pix2arcmin/60) ) );


	%%  TIMING
	% note: dot drawing is done frame-by-frame rather than using PTB WaitSecs,
	% this seems to provide better precision, although time is still not
	% perfect (a few frames tend to be dropped)

	% duration to hold dots on screen	
	params.dotUpdateSec    = 1/stimset.dotUpdateHz;                                
	% number of frames to hold dots on screen	
	params.dotRepeats		= round(videoMode.frameRate/stimset.dotUpdateHz);
	% number of times the stimulus is updated in a rap cycle
    
	% number of times the stimulus is updated in a preclue
	params.preludeUpdates  = round(stimset.dotUpdateHz*stimset.preludeSec);
	
	params.prelude = zeros(1, params.preludeUpdates);
    
    
    rampDisparity = linspace(params.rampEndDispPix/params.numUpdates, ...
            params.rampEndDispPix, params.numUpdates);
   
    if (~stimset.isPeriodic)
        params.ramp = rampDisparity;
    else
        params.ramp = repmat([rampDisparity, rampDisparity(end:-1:1)], [1 stimset.cycleSec]);
    end

     params.step = params.dispPix*ones(size(params.ramp));
   
	% conditions should not don't exceed calibration area
	isTooBigForRamp = max(params.ramp/2) > videoMode.caliRadiusPixX;
	isTooBigForStep = max(params.step/2) > videoMode.caliRadiusPixX;

	
	if(isTooBigForRamp || isTooBigForStep)
		warning('need to increase calibration area in order to run this condition');
    end

% 	%%  TRIAL STRUCTURE 
% 	combTrials = allcombs(stimset.conditions, stimset.dynamics, stimset.directions);
% 	
% 	
% % 	trials.condition        = {};	
% % 	trials.dynamics         = {};
% % 	trials.direction        = {};
% % 	% 
% % 	
% % 	trials.repeat           = [];	
% % 
% % 	for c = 1:length(stimset.conditions)
% %     
% % 		for d = 1:length(stimset.dynamics)
% %         
% % 			for n = 1:length(stimset.directions)
% %             
% % 				for r = 1:stimset.cond_repeats
% %                 
% % 					trials.condition    = [stim_session.trials.condition ; stimset.conditions{c}];
% % 					trials.dynamics     = [stim_session.trials.dynamics ; stimset.dynamics{d}];
% % 					trials.direction    = [stim_session.trials.direction ; stimset.directions{n}];
% % 					trials.repeat       = [stim_session.trials.repeat ; r];
% %                 
% % 				end
% % 			end     
% % 		end
% % 	end
% 	
% 	% randomize trial order
% 	trials.trialnum = randperm(length(combTrials));
% 
% 	% emptry response arrays
% 	trials.resp         = cell(1, length(trials.condition));
% 	trials.respCode     = NaN*ones(1, length(trials.condition));
% 	trials.isCorrect    = zeros(1, length(trials.condition));
% 
% 	% generate random delay period for each trial
% 	trials.delayTimeSec = randi([250 750], 1, length(trials.condition))./1000;
% 	;


	%% SOUND %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	cf = 1000;                  % carrier frequency (Hz)
	sf = 22050;                 % sample frequency (Hz)
	d = 0.1;                    % duration (s)
	n = sf * d;                 % number of samples
	s = (1:n) / sf;             % sound data preparation
	s = sin(2 * pi * cf * s);   % sinusoidal modulation
	params.sound.s = s;
	params.sound.sf = sf;

	cf = 2000;                  % carrier frequency (Hz)
	sf = 22050;                 % sample frequency (Hz)
	d = 0.1;                    % duration (s)
	n = sf * d;                 % number of samples
	s = (1:n) / sf;             % sound data preparation
	s = sin(2 * pi * cf * s);   % sinusoidal modulation
	params.sound.sFeedback = s;
	params.sound.sfFeedback = sf;
end

