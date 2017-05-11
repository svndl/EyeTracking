function stimset = bars(videoMode)
    % condition structure:
    % conditions.fhandle : function handle that will return barframes
    % conditions.fparams: arguments to function handle
    % conditions.info: stim info with the following fields:
    
    % info.nTrilas - # of repeats
    % info.cues
    % info.dynamic
    % info.direction
    % info.dotSize, etc ...
   
    
    % define simple stimset
    
    corrbar = barProp(1,videoMode);
   
    antibar = barProp(-1,videoMode);
     uncorrbar = barProp(0,videoMode);
 
     %params = {uncorrbar};
     
     params = {corrbar, uncorrbar, antibar};
 
     %params = {corrbar, antibar,uncorrbar};
    
     
    directions = {'towards', 'away'};
     
    stimset  = cell(numel(params)*numel(directions), 1);
    c = 1; 
    for p = 1: numel(params) 
        for d = 1:numel(directions)
            info = params{p};
            info.direction = directions(d);            
            stimset{c}.fhandle = info.handle;
            stimset{c}.fparams = {info, videoMode};
            stimset{c}.info = info;
            c = c + 1;
        end
    end
end


function bars = barProp(correlation,videoMode)
    % set up properties
    
    bars.drawHandle = 'drawBars';
    bars.handle = 'BarFrame';
    switch correlation
        case 1
            bars.correlation = 1;
            bars.name = 'correlated';
        case 0 
            bars.correlation = 0;
            bars.name = 'uncorrelated';
        case -1
            bars.correlation = -1;
            bars.name = 'anticorrelated';
    end
                     
    bars.dynamics = {'ramp'};
 	bars.isPeriodic = 0;

    bars.nonius.enable    = 1;      % nonius on during trial (1) or not(0)
    bars.nonius.heightDeg = 3;
    bars.nonius.widthDeg  = 0.25;
    
    bars.nonius.upDeg     = 2;
    bars.nonius.fixDotDeg = 1;
    bars.nonius.color = 255;
    

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               Setup bar field properties             %
    %                                                      %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    
	%bars.stimRadDeg      = 20;     % stimulus field radius
	%bars.dispArcmin      = 120;    % disparity magnitude
	bars.shiftPerSec = 40;      % shifting speed in degrees per second
	bars.rampSpeedDegSec = bars.shiftPerSec;
	
    bars.minWidth      = 20;  %(AMN Nov 3)   % minimum width in arcmin for each bar
    bars.width = 0.5*videoMode.width_pix;
    bars.height = 0.5*videoMode.height_pix;
	% timing
	bars.preludeSec      = 0.8;    % delay before motion onset
	bars.cycleSec        = .4;      % duration of stimulus after prelude
	bars.nTrials         = 20;      % number of repeats per condition
	
	% dot update params
	bars.dotUpdateHz     = 60;        
	bars.numCycles       = 1;     
end
