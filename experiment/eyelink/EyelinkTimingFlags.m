function timing = EyelinkTimingFlags(timingOpts)
%function will return a structure with timing flags and their locations in
% asc/edf (not done yet) files
% we'll use the flags to cut the trial data out of the file 
    switch(timingOpts)
        case 'default'
            timing.startCol = 1;
            timing.stopCol = 1;
            
            timing.startFlag = 'START';
            timing.stopFlag = 'STOP';
        case 'message'
            
            timing.startCol = 2;
            timing.stopCol = 2;
            
            timing.startFlag = 'StartTrial';
            timing.stopFlag = 'StopTrial';
        otherwise
            timing.startCol = 1;
            timing.stopCol = 1;
            
            timing.startFlag = 'START';
            timing.stopFlag = 'STOP';            
    end
end
