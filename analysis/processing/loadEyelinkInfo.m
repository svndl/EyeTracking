function el = loadEyelinkInfo
% load eyelink tracker settings

    % eyetracker sample rate in Hz
    % el.sampleRate  = 1000;
    % resampling rate (samples - > milliseconds)
	
    el.resampleRate  = 1000;                                  
    
    % distance from camera to subject's head
    el.href_dist   = 50;                   
    % conversion factor between HREF units and cm    
    el.href2cm = (el.href_dist/15000);
end

