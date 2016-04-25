function cdot = CDOTS_dots

	% set up properties
    cdot.cues = 'CDOT';                 
    cdot.dynamics = {'ramp'};
	cdot.isPeriodic = 0;

    cdot.nonius          = 1;      % nonius on during trial (1) or not(0)

	% dot field properties
	cdot.stimRadDeg      = 20;     % stimulus field radius
	cdot.dispArcmin      = 120;    % disparity magnitude
	cdot.rampSpeedDegSec = 1;      % ramp speed in degrees per second
	cdot.dotSizeDeg      = 0.4;     % diameter of each dot
	cdot.dotDensity      = .2;     % dots per degree2

	% timing
	cdot.preludeSec      = 0.25;   % delay before motion onset
	cdot.cycleSec        = 2;      % duration of stimulus after prelude
	cdot.nTrials         = 1;      % number of repeats per condition
	
	% dot update params
	cdot.dotUpdateHz     = 60;        
	cdot.numCycles       = 1;         
end