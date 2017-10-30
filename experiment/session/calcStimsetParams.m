function params = calcStimsetParams(stimset, videoMode)
	
	%%SCREEN 
    
    if stimset.dispArcmin < videoMode.pix2arcmin 
		warning('disparity requested is less than 1 pixel');
    end
    
    % copy and replace defaultParams field;
    params = getDefaultParams;
    
    fn = fieldnames(stimset);
    
    for n = 1:numel(fn)
        params.(fn{n}) = stimset.(fn{n});
    end
    
    %%  STIMULUS
	params.dispPix = params.dispArcmin/videoMode.pix2arcmin;
    
    % deal with periodic motion
    
    if (~params.isPeriodic)
        rampEndDispDeg      = (params.rampSpeedDegSec*params.cycleSec);
        params.nFrames = round(params.dotUpdateHz*params.cycleSec);
    else
        rampEndDispDeg = params.rampSpeedDegSec;
        params.nFrames = round(0.5*params.dotUpdateHz);
    end
    
    params.rampEndDispPix  = (60*rampEndDispDeg)/videoMode.pix2arcmin;
	
	params.stimRadPix      = round((60*params.stimRadDeg)/videoMode.pix2arcmin);    
	params.stimRadSqPix    = params.stimRadPix^2;                            
	params.dotSizePix      = (params.dotSizeDeg*60)/videoMode.pix2arcmin;         

	% full x field of dots before circle crop	
	
	params.xmax            = max([params.stimRadPix params.rampEndDispPix]);   
	params.ymax            = params.xmax;                                  
	
% 	params.numDots = round( stimset.dotDensity*(  params.xmax*(videoMode.pix2arcmin/60)*...
%       params.ymax*(videoMode.pix2arcmin/60) ) );
% 
    params.numDots = round(params.dotDensity*(params.stimRadSqPix/((params.dotSizePix/2)^2)));

	%%  TIMING
	% note: dot drawing is done frame-by-frame rather than using PTB WaitSecs,
	% this seems to provide better precision, although time is still not
	% perfect (a few frames tend to be dropped)

	% duration to hold dots on screen	
	params.dotUpdateSec    = 1/params.dotUpdateHz;                                
	% number of frames to hold dots on screen	
	params.dotRepeats		= round(videoMode.frameRate/params.dotUpdateHz);
	% number of times the stimulus is updated in a rap cycle
    
	% number of times the stimulus is updated in a preclue
	params.preludeUpdates  = round(params.dotUpdateHz*params.prelude.durationSec);
	
	params.prelude = zeros(1, params.preludeUpdates);
    
    
    rampDisparity = linspace(params.rampEndDispPix/params.nFrames, ...
            params.rampEndDispPix, params.nFrames);
   
    if (~params.isPeriodic)
        params.ramp = rampDisparity;
    else
        params.ramp = repmat([rampDisparity, rampDisparity(end:-1:1)], [1 params.cycleSec]);
    end
    

    params.step = params.dispPix*ones(size(params.ramp));
   
	% conditions should not don't exceed calibration area
	isTooBigForRamp = max(params.ramp/2) > videoMode.clbRadiusX;
	isTooBigForStep = max(params.step/2) > videoMode.clbRadiusX;

	
	if(isTooBigForRamp || isTooBigForStep)
		warning('need to increase calibration area in order to run this condition');
    end    
end

