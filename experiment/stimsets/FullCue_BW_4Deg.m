function stimset = FullCue_BW_4Deg(videoMode)
    % condition structure:
    % conditions.fhandle : function handle that will return dotFrames, dotColor and dotSize
    % conditions.fparams: arguments to function handle
    % conditions.info: stim info with the following fields:
    
    % info.nTrilas - # of repeats
    % info.cues
    % info.dynamic
    % info.direction
    % info.dotSize, etc ...
   
    
    % define simple stimset#2

    fc = eval('FullCue_dots');
    fc.handle = 'DotFrames';
    fc.name = 'Full Cue';
    
    % white dots
    fc.color = [255 255 255];
    
	fc.rampSpeedDegSec = 1;      % ramp speed in degrees per second
	fc.dotSizeDeg      = 0.25;    % diameter of each dot
	fc.dotDensity      = .2;     % dots per degree2
 
	% timing
	fc.preludeSec      = 0.5;    % delay before motion onset
	fc.cycleSec        = 2;      % duration of stimulus after prelude
	fc.nTrials         = 20;      % number of repeats per condition
    
    customVideoMode = videoMode;
    
    %% modify the background color
    customVideoMode.background = [0 0 0];
    
    params = {fc};
    
    directions = {'towards', 'away'};
    
    stimset = cell(numel(params)*numel(directions), 1);
    c = 1;
    for p = 1: numel(params)
        for d = 1:numel(directions)
            info = params{p};
            info.direction = directions(d);
            stimset{c}.fhandle = info.handle;
            stimset{c}.fparams = {info, customVideoMode};
            stimset{c}.info = info;
            
            c = c + 1;
        end
    end
end
