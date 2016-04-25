function fc = FullCue_dots

	% set up properties
    fc.cues = 'FullCue';                 
    fc.dynamics = {'ramp'};
	fc.isPeriodic = 0;

    fc.nonius          = 1;      % nonius on during trial (1) or not(0)

	% dot field properties
	fc.stimRadDeg      = 20;     % stimulus field radius
	fc.dispArcmin      = 120;    % disparity magnitude
	fc.rampSpeedDegSec = 1;      % ramp speed in degrees per second
	fc.dotSizeDeg      = 0.4;     % diameter of each dot
	fc.dotDensity      = .2;     % dots per degree2

	% timing
	fc.preludeSec      = 0.25;   % delay before motion onset
	fc.cycleSec        = 2;      % duration of stimulus after prelude
	fc.nTrials         = 1;      % number of repeats per condition
	
	% dot update params
	fc.dotUpdateHz     = 60;        
	fc.numCycles       = 1;         
end