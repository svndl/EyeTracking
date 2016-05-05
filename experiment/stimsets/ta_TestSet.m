function stimset = ta_TestSet(videoMode)
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
    fc.handle = 'mixedDotFrames';
    fc.name = 'Full Cue';
    
    decorr = eval('IOVD_dots');
    decorr.handle = 'mixedDotFrames';
    decorr.name = 'Decorrelated';
    
    anti = eval('AntiCorr_dots');
    anti.handle = 'antiCorrDotFrames';
    anti.name = 'Anticorrelated';
    
    cdot = eval('CDOT_dots');
    cdot.handle = 'mixedDotFrames';
    cdot.name = 'CDOT';
    
    params = {fc, cdot, decorr, anti};
    %params = {fc};
    
    directions = {'towards', 'away'};
    
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