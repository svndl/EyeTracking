function stimset = ta_TestSet(videoMode)
    % condition structure:
    % conditions.fhandle : function handle that will return dotFrames, dotColor and dotSize
    % conditions.fparams: arguments to function handle
    % conditions.info: stim info with the following fields:
    
    % info.nTrilas - # of repeats
    % info.cues
    % info.dynamic
    % info.direction
   
    
    % define simple stimset#2

    fc = eval('FullCue_dots');
    fc.handle = 'mixedDotFrames';
%     
%     decorr = eval('De-Anti_Corr_dots');
%     decorr.handle = 'mixedDotFrames';
%       
%     anti = eval('IOVD_dots');
%     anti.handle = 'antiCorrDotFrames';
    
%     cdot = eval('CDOT_dots');
%     cdot.handle = 'mixedDotFrames';

    params = {fc};
    
    %params = {fc, cdot, iovd_corr, iovd_anti};
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