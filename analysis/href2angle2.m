function [x, y, z] =  href2angle2(hrefL, hrefR, ipd)
    % converting href coordinates to meaningful values
    % hrefX, hrefY -- raw HREF eye coordinates
    % ipd -- interpupil distance
    % td -- horizontal distance to the eyetracker
    
    f = 15000;
    %correction for each eye
    hc = f*(0.5*ipd)/td;
    
    Hxl = hrefL(:, 1) + hc;
    Hxr = hrefR(:, 1) - hc;
    
    %vergence 
    vergence = Hxl - Hxr;
    %(distance estimate from vergence)
    
    %x, y, z coordinate of where the subject is looking at in the physical space
    z = f/vergence*ipd; 
    
    x(:, 1) = Hxl*z/f - ipd/2;
    x(:, 2) = Hxr * z/f + ipd/2;
    y(:, 1) = hrefL(:, 2)*z/f;
    y(:, 2) = hrefR(:, 2)*z/f;
end