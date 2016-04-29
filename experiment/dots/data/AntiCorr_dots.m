function antiCorr = AntiCorr_dots

    antiCorr.cues = 'FullCue';                 
    antiCorr.dynamics = {'ramp'};
	antiCorr.isPeriodic = 0;

	% set up properties
	antiCorr.nonius          = 1;      % nonius on during trial (1) or not(0)

	% dot field properties
	antiCorr.stimRadDeg      = 20;     % stimulus field radius
	antiCorr.dispArcmin      = 120;    % disparity magnitude
	antiCorr.rampSpeedDegSec = .75;      % ramp speed in degrees per second
	antiCorr.dotSizeDeg      = 0.4;     % diameter of each dot
	antiCorr.dotDensity      = .2;     % dots per degree2

	% timing
	antiCorr.preludeSec      = 0.5;   % delay before motion onset
	antiCorr.cycleSec        = 2;      % duration of stimulus after prelude
	antiCorr.nTrials         = 5;      % number of repeats per condition
	
	% dot update params
	antiCorr.dotUpdateHz     = 60;        
	antiCorr.numCycles       = 1;         
end