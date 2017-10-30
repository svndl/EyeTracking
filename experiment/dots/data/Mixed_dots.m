function mixed = Mixed_dots

	% set up properties
    mixed.cues = 'Mixed';                 
    mixed.dynamics = {'ramp'};
	mixed.isPeriodic = 0;

    mixed.nonius          = 1;      % nonius on during trial (1) or not(0)

	% dot field properties
	mixed.stimRadDeg      = 20;     % stimulus field radius
	mixed.dispArcmin      = 120;    % disparity magnitude
	mixed.rampSpeedDegSec = 1;      % ramp speed in degrees per second
	mixed.dotSizeDeg      = 0.4;     % diameter of each dot
	mixed.dotDensity      = .2;     % dots per degree2

	% timing
	mixed.prelude.durationSec      = 0.25;   % delay before motion onset
	mixed.cycleSec        = 2;      % duration of stimulus after prelude
	mixed.nTrials         = 1;      % number of repeats per condition
	
	% dot update params
	mixed.dotUpdateHz     = 60;        
	mixed.numCycles       = 1;         
end