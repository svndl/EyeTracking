function [angleL, angleR] = href2angle(hrefL0, hrefR0, ipd)
    % hrefL, R -- headref coordinates (x, y) of left and right eyes;
    % ipd -- interpupil distance
    
    % defined by eyelink
    f = 15000;

    % dataSamples size: 
    dataSamples = size(hrefL0);
    samplesPerTrial = dataSamples(1);
    nVars =  dataSamples(2);
    nTrials = dataSamples(3);
    
    %
    hrefL = reshape(ipermute(hrefL0, [1 3 2]), [samplesPerTrial*nTrials nVars]);    
    hrefR = reshape(ipermute(hrefR0, [1 3 2]), [samplesPerTrial*nTrials nVars]);    
    
    nSamples = size(hrefL, 1);

    
    % ancor points for left & right eye
    L0 = repmat([-0.5*ipd 0], [nSamples 1]);
    R0 = repmat([0.5*ipd 0], [nSamples 1]);
    
    % eye rotation angles with regards to anchor points;
    
    aL = acos( (f^2 + sum(L0.*hrefL, 2))./sqrt( (f^2 + sum(hrefL.^2, 2)) .* (f^2 + sum(L0.^2, 2))));
    aR = acos( (f^2 + sum(R0.*hrefR, 2))./sqrt( (f^2 + sum(hrefR.^2, 2)) .* (f^2 + sum(R0.^2, 2))));
    
    
    % directional angle between two axes
    dirL = atan2(hrefL(:, 1) - L0(:, 1), hrefL(:, 2) - L0(:, 2));
    dirR = atan2(hrefR(:, 1) - R0(:, 1), hrefR(:, 2) - R0(:, 2));
    
    % x and y components of angular rotation for each eye
    
    angleL0 = 180*[sin(dirL).*aL cos(dirL).*aL]/pi;
    angleR0 = 180*[sin(dirR).*aR cos(dirR).*aR]/pi;
    
    %%reshape back
    angleL = ipermute(reshape(angleL0, [samplesPerTrial nTrials nVars]),  [1 3 2]);    
    angleR = ipermute(reshape(angleR0, [samplesPerTrial nTrials nVars]),  [1 3 2]);
end