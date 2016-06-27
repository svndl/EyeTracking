function tSec = EyelinkGetTrackerTime
% function will return current tracker time (in seconds)
% since the tracker application started.

    tSec = 0;
    
    if (Eyelink('IsConnected') == 1)
        tSec = Eyelink('TrackerTime');
    end
end