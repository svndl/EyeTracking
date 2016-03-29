function el = loadEyelinkInfo
% load in importatn eyelink data info

    warning('Loading in Eyelink measurement info - make sure settings were not changed');
    % eyetracker sample rate in Hz
    el.sampleRate  = 1000;                 
    % viewing distance in cm    
    el.href_dist   = 50;                   
    % conversion factor between HREF units and cm    
    el.href2cm     = (el.href_dist/15000);
end

