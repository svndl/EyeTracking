function stimset = SingleDotSteps(videoMode)
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

    fc = eval('SingleDot_dots');
    fc.handle = 'DotFrames';
    fc.name = 'Single Dot';
    
    
    %params = {fc, cdot, decorr, anti};
    params = {fc};
    
    directions = {'left', 'right'};
    
    stimset = cell(numel(params)*numel(directions), 1);
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
