function trials = processEyelinkFile_edfmex(pathToFile)
% Function will load eyelink raw file with all trials data into the structure  
%
% typedef struct {
% UINT32 time; /* time stamp of sample */ 
% UINT16 flags; /* flags to indicate contents */ 
% float px [2], py [2]; /* pupil x, y */ 
% float hx [2], hy [2]; /* headref x, y */ 
% float pa [2]; /* pupil size or area */ 
% float gx [2], gy [2]; /* screen gaze x, y (pixels) */ 
% float rx, ry; /* screen pixels per degree */ 
% UINT16 status; /* tracker status flags */ 
% UINT16 input; /* extra (input word) */ 
% UINT16 buttons; /* button state & changes */ 
% INT16 htype; /* head-tracker data type (0=none) */ 
% INT16 hdata [8]; /* head-tracker data (not pre-scaled) */ 
% UINT16 errors; /* process error flags */ 
% float gxvel [2], gyvel [2]; /* gaze x, y velocity */ 
% float hxvel [2], hyvel [2]; /* headref x, y velocity */ 
% float rxvel [2], ryvel [2]; /* raw x, y velocity */ 
% float fgxvel [2], fgyvel; /* fast gaze x, y velocity */ 
% float fhxvel [2], fhyvel [2]; /* fast headref x, y velocity */
% float frxvel [2], fryvel [2]; /* fast raw x, y velocity */ 
% } FSAMPLE;
% 

% After loading the trial info, data vectors will be broken by # trials

    eyelinkData = edfmex(pathToFile); 
    timeEvents = [eyelinkData.RECORDINGS.time];
    
    starts = timeEvents([eyelinkData.RECORDINGS.state] == 1);
    stops = timeEvents([eyelinkData.RECORDINGS.state] == 0);
    idx_starts = starts - starts(1) + 1;
    idx_stops = stops - starts(1);
    
    duration = stops - starts;
             
    % headref coordinates
    hrefX = [eyelinkData.FSAMPLE.hx]';
    hrefY = [eyelinkData.FSAMPLE.hy]';
        
    % headref velocity
    hrefVelX = [eyelinkData.FSAMPLE.hxvel]';
    hrefVelY = [eyelinkData.FSAMPLE.hyvel]';    
        
    trials = cell(numel(starts), 1);
    
    % we'll keep HREF pos and speed 
    fields = {'time', 'Lx', 'Ly', 'Rx', 'Ry', 'Lvx', 'Lvy', 'Rvx', 'Rvy'}; 

    for s = 1:length(starts)    
        try
            %indexes corresponding to the trial  
            idx_t = idx_starts(s):idx_stops(s);
            timeSamples = (1:duration(s))';
            % data is arranged by var_left(x, y) var_right(x, y) 
            goodTrials = [timeSamples 
                hrefX(idx_t, 1) hrefY(idx_t, 1) ...
                hrefX(idx_t, 2) hrefY(idx_t, 2) ...
                hrefVelX(idx_t, 1) hrefVelY(idx_t, 1) ...
                hrefVelX(idx_t, 2) hrefVelY(idx_t, 2)];
        catch err
            display(['processEyelinkFile Error trial #'  num2str(s)  ' file ' ...
                pathToFile ' caused by:']);
            display(err.message);
            display(err.stack(1).file);
            display(err.stack(1).line);
                        
            % keep whatever we have parsed so far
            goodTrials = data;
        end
        trials{s}.data = goodTrials;
        trials{s}.headers = fields; 
    end
end