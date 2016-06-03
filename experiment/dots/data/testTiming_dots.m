function test = testTiming_dots

	% set up properties
    test.cues = 'CDOT';                 
    test.dynamics = {'step'};
    test.direction = {'right'};
    
	test.isPeriodic = 0;

    test.nonius          = 1;      % nonius on during trial (1) or not(0)

	% dot field properties
	test.stimRadDeg      = 20;     % stimulus field radius
	test.dispArcmin      = 120;    % disparity magnitude
	test.rampSpeedDegSec = .5;      % ramp speed in degrees per second
	test.dotSizeDeg      = 0.4;     % diameter of each dot
	test.dotDensity      = .2;     % dots per degree2

	% timing
	test.preludeSec      = 1;   % delay before motion onset
	test.cycleSec        = 2;      % duration of stimulus after prelude
	test.nTrials         = 20;      % number of repeats per condition
	
	% dot update params
	test.dotUpdateHz     = 60;        
	test.numCycles       = 1;         
end