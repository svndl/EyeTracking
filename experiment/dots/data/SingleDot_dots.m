function dot = SingleDot_dots
    
    dot.cues = 'SingleDot';                 
    dot.dynamics = {'step', 'ramp'};
	dot.isPeriodic = 0;

	% set up properties
	dot.nonius          = 0;      % nonius on during trial (1) or not(0)

	% dot field properties
	dot.stimRadDeg      = 20;     % stimulus field radius
	dot.dispArcmin      = 240;    % disparity magnitude
	dot.rampSpeedDegSec = 2;      % ramp speed in degrees per second
	dot.dotSizeDeg      = 0.6;     % diameter of each dot
	dot.dotDensity      = .2;     % dots per degree2

	% timing
	dot.prelude.durationSec      = 0.25;   % delay before motion onset
	dot.cycleSec        = 2;      % duration of stimulus after prelude
	dot.nTrials         = 5;      % number of repeats per condition
	
	% dot update params
	dot.dotUpdateHz     = 60;        
	dot.numCycles       = 1;         
end