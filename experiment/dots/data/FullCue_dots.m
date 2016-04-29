function fcdot = FullCue_dots

	% set up properties
    fcdot.cues = 'FullCue';                 
    fcdot.dynamics = {'ramp'};
	fcdot.isPeriodic = 0;

    fcdot.nonius          = 1;      % nonius on during trial (1) or not(0)

	% dot field properties
	fcdot.stimRadDeg      = 20;     % stimulus field radius
	fcdot.dispArcmin      = 120;    % disparity magnitude
	fcdot.rampSpeedDegSec = .75;      % ramp speed in degrees per second
	fcdot.dotSizeDeg      = 0.4;     % diameter of each dot
	fcdot.dotDensity      = .2;     % dots per degree2

	% timing
	fcdot.preludeSec      = 0.5;    % delay before motion onset
	fcdot.cycleSec        = 2;      % duration of stimulus after prelude
	fcdot.nTrials         = 5;      % number of repeats per condition
	
	% dot update params
	fcdot.dotUpdateHz     = 60;        
	fcdot.numCycles       = 1;         
end