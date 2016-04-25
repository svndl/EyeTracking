function stimset = testCalibrationStimset(videoMode)
    % condition structure:
    % conditions.fhandle : function handle that will return dotFrames, dotColor and dotSize
    % conditions.fparams: arguments to function handle
    % conditions.info: stim info with the following fields:
    
    % info.nTrilas - # of repeats
    % info.cues
    % info.dynamic
    % info.direction
   
    
    % define simple stimset#2
    
    mix = eval('Mixed_dots');
    mix.handle = 'mixedDotFrames';

    fc = eval('FullCue_dots');
    fc.handle = 'mixedDotFrames';
    
    iovd_corr = eval('IOVD_dots');
    iovd_corr.handle = 'mixedDotFrames';
      
    iovd_anti = eval('IOVD_dots');
    iovd_anti.handle = 'antiCorrDotFrames';
    
    cdot = eval('CDOT_dots');
    cdot.handle = 'mixedDotFrames';

    cdot_anti = eval('CDOT_dots');
    cdot_anti.handle = 'antiCorrDotFrames';

    dot = eval('SingleDot_dots');
    dot.handle = 'DotFrames';
    
    
    params = {mix, fc, iovd_corr, iovd_anti, cdot, cdot_anti, dot};
    directions = {'left', 'away'};
    
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