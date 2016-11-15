function params = bar_calcStimsetParams(stimset, videoMode)



%width, height, minWidth, cor, displacement, direction,dur,nframe, scr
params.width = stimset.width;
params.height = stimset.height;
params.minWidth = round(stimset.minWidth/videoMode.pix2arcmin);
if(params.minWidth < 1)
    params.minWidth = 1;
    warning('minWidth of the bar requested is less than 1 pixel, and it is set to 1 pixel per frame');
end

params.cor = stimset.correlation;

shiftPerSecPix = stimset.shiftPerSec*60/videoMode.pix2arcmin; %convert degree to pixels
params.displacementPix = round(shiftPerSecPix / videoMode.frameRate)
if(params.displacementPix < 1)
    params.displacementPix = 1;
    warning('bar displacement per frame requested is less than 1 pixel, and it is set as 1 pixel per frame');
end

params.direction = stimset.direction{:};
params.dur = stimset.cycleSec;



% deal with periodic motion

if (~stimset.isPeriodic)
    %rampEndDispDeg      = (stimset.rampSpeedDegSec*stimset.cycleSec);
    params.nFrames = round(stimset.dotUpdateHz*stimset.cycleSec);
else
    rampEndDispDeg = stimset.rampSpeedDegSec;
    params.nFrames = round(0.5*stimset.dotUpdateHz);
end



end


%params.rampEndDispPix  = (60*rampEndDispDeg)/videoMode.pix2arcmin;

% 	params.stimRadPix      = round((60*stimset.stimRadDeg)/videoMode.pix2arcmin);
% 	params.stimRadSqPix    = params.stimRadPix^2;
% 	params.dotSizePix      = (stimset.dotSizeDeg*60)/videoMode.pix2arcmin;

% full x field of dots before circle crop

% 	params.xmax            = max([params.stimRadPix params.rampEndDispPix]);
% 	params.ymax            = params.xmax;

% 	params.numDots = round( stimset.dotDensity*(  params.xmax*(videoMode.pix2arcmin/60)*...
%       params.ymax*(videoMode.pix2arcmin/60) ) );
%
%     params.numDots = round(stimset.dotDensity*(params.stimRadSqPix/(pi*(params.dotSizePix/2)^2)));

%%  TIMING
% note: dot drawing is done frame-by-frame rather than using PTB WaitSecs,
% this seems to provide better precision, although time is still not
% perfect (a few frames tend to be dropped)

% duration to hold dots on screen
%params.dotUpdateSec = 1/stimset.dotUpdateHz;
% number of frames to hold dots on screen
%params.dotRepeats	= round(videoMode.frameRate/stimset.dotUpdateHz);
% number of times the stimulus is updated in a rap cycle

% number of times the stimulus is updated in a preclue
%params.preludeUpdates  = round(stimset.dotUpdateHz*stimset.preludeSec);

%params.prelude = zeros(1, params.preludeUpdates);


%     rampDisparity = linspace(params.rampEndDispPix/params.nFrames, ...
%             params.rampEndDispPix, params.nFrames);
%
%     if (~stimset.isPeriodic)
%         params.ramp = rampDisparity;
%     else
%         params.ramp = repmat([rampDisparity, rampDisparity(end:-1:1)], [1 stimset.cycleSec]);
%     end
%
%      params.step = params.dispPix*ones(size(params.ramp));

% conditions should not don't exceed calibration area
% 	isTooBigForRamp = max(params.ramp/2) > videoMode.clbRadiusX;
% 	isTooBigForStep = max(params.step/2) > videoMode.clbRadiusX;
%
%
% 	if(isTooBigForRamp || isTooBigForStep)
% 		warning('need to increase calibration area in order to run this condition');
%     end



