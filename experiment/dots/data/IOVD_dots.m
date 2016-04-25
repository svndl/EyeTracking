function iovd = IOVD_dots

    iovd.cues = 'IOVD';                 
    iovd.dynamics = {'ramp'};
	iovd.isPeriodic = 0;

	% set up properties
	iovd.nonius          = 1;      % nonius on during trial (1) or not(0)

	% dot field properties
	iovd.stimRadDeg      = 20;     % stimulus field radius
	iovd.dispArcmin      = 120;    % disparity magnitude
	iovd.rampSpeedDegSec = 1;      % ramp speed in degrees per second
	iovd.dotSizeDeg      = 0.4;     % diameter of each dot
	iovd.dotDensity      = .2;     % dots per degree2

	% timing
	iovd.preludeSec      = 0.25;   % delay before motion onset
	iovd.cycleSec        = 2;      % duration of stimulus after prelude
	iovd.nTrials         = 1;      % number of repeats per condition
	
	% dot update params
	iovd.dotUpdateHz     = 60;        
	iovd.numCycles       = 1;         
end