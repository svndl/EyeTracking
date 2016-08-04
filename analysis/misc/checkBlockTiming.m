function [missedFrames, samplesPerBlock] = checkBlockTiming(timingPTB, timingEyelink)

    % function checks for missed frames during trial presentation in timingPTB 
    % returns eyelink samples for every trial
    
    nTrials = numel(timingEyelink);
    nFrames = size(timingPTB(1).StimulusReqTime, 2);

    %vblTime = reshape(cat(2, timingPTB(1:end).VBLTimestamp), [nFrames nTrials]);
    missed = reshape(cat(2, timingPTB(1:end).Missed), [nFrames nTrials]);
    missedFrames = sum(missed>0);
    
    samplesPerBlock = checkEyelinkData(timingEyelink);
    disp([ '  missed Frames :' num2str(missedFrames)]);
    disp([ '  Eyelink samples :' num2str(samplesPerBlock)]);    
end

function samplesPerBlock = checkEyelinkData(cndEyeData)
    nTrials = numel(cndEyeData);
    samplesPerBlock = zeros(1, nTrials);
    for t = 1:nTrials; 
        samplesPerBlock(t) = size(cndEyeData{t}, 1);
    end
end



