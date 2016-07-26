function isTrialOK = rejectBadTrials(quality, timing, varargin)
    %function checks trial timing and sample quality and rejects/accepts trial
    
    % max bad samples 15 percent 
    maxBadSamples = 0.15; 
    sampleIsGood = (cellfun(@sum, quality)./cellfun(@length, quality)) ...
        > (1 - maxBadSamples);
    
    maxMissedFrames = 2;
   
    timingIsGood = (cellfun(@sum, timing)) <= maxMissedFrames;
    isTrialOK = boolean(sampleIsGood.*timingIsGood);
end