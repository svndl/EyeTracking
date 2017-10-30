function p = getDefaultParams
% Function will return params structure with default values 


    %% stimulus
	% dot field properties
	p.stimRadDeg      = 20;     % stimulus field radius
	p.dispArcmin      = 120;    % disparity magnitude
	p.rampSpeedDegSec = .75;      % ramp speed in degrees per second
	p.dotSizeDeg      = 0.4;     % diameter of each dot
	p.dotDensity      = .2;     % dots per degree2
    p.cues = 'FullCue';                 
    p.dynamics = {'ramp'};
    p.direction = {'towards'};
	p.isPeriodic = 0;

	% timing
	p.cycleSec        = 2;      % duration of stimulus after prelude
	p.nTrials         = 5;      % number of repeats per condition
	
	% dot update params
	p.dotUpdateHz     = 60;        
	p.numCycles       = 1;         

    %% prelude
	p.prelude.durationSec = 0.5;     % prelude duration
	p.prelude.waitAfter   = 0.1;     % blank delay before motion onset
	p.prelude.type        = 'blank'; % prelude type

    %% nonius
    p.nonius.enable    = 1;      % nonius on during trial (1) or not(0)
    p.nonius.heightDeg = 3;
    p.nonius.widthDeg  = 0.25;
    
    p.nonius.upDeg     = 2;
    p.nonius.fixDotDeg = .5;
    p.nonius.color = 255;
end