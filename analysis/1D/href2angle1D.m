function [angleL, angleR] = href2angle1D(hrefL0, hrefR0, ipd)
    % hrefL, R -- headref coordinates (x, y) of left and right eyes;
    % ipd -- interpupil distance
    
    % defined by eyelink
    f = 10000;

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
    
    angleL0 = acos( (f^2 + sum(L0.*hrefL, 2))./sqrt( (f^2 + sum(hrefL.^2, 2)) .* (f^2 + sum(L0.^2, 2))));
    angleR0 = acos( (f^2 + sum(R0.*hrefR, 2))./sqrt( (f^2 + sum(hrefR.^2, 2)) .* (f^2 + sum(R0.^2, 2))));
    angleL = 180*reshape(angleL0, [samplesPerTrial nTrials])/pi;    
    angleR = 180*reshape(angleR0, [samplesPerTrial nTrials])/pi;
end