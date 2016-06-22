function lateFrames = checkSessionTiming(sessionData)
    
    %% load session matfile
    %% for each conditions, get frame display statistic 
    
    nCnd = numel(sessionData);
    lateFrames = cell(nCnd, 1);
    for nc = 1:nCnd
        cndTiming = sessionData{nc}.timing;
        cndEyeData = sessionData{nc}.data;
        [ifiPTB, lateFrames{nc}] = checkCndTiming(cndTiming);
        subplot(nCnd, 1, nc), plot(round(1000*ifiPTB)), title(['Interframe interval condition' num2str(nc)]); hold on;
        samplesPerCnd = checkEyelinkData(cndEyeData);
        disp([ 'Condition ' num2str(nc) '  missed Frames :' num2str(lateFrames{nc})]);
        disp([ 'Condition ' num2str(nc) '  Eyelink samples :' num2str(samplesPerCnd)]);
        
        %eyelink Trial Data
    end
end
function [ifiPTB, lateFrames] = checkCndTiming(cndTiming)
    nTrials = numel(cndTiming);
    nFrames = size(cndTiming(1).StimulusReqTime, 2);
    reqTime = reshape(cat(2, cndTiming(1:end).StimulusReqTime), [nFrames nTrials]);
    dsplTime = reshape(cat(2, cndTiming(1:end).StimulusOnsetTime), [nFrames nTrials]);
    vblTime = reshape(cat(2, cndTiming(1:end).VBLTimestamp), [nFrames nTrials]);
    
    ifiPTB = diff(vblTime);
    
    % concatenate trial timing into one matrix
    ifiReq = diff(reqTime);
    ifiDspl = diff(dsplTime);
    lateFrames = sum(ifiDspl> 1.2*mean(ifiReq(:)));    
end
function samplesPerCnd = checkEyelinkData(cndEyeData)
    nTrials = numel(cndEyeData);
    samplesPerCnd = zeros(1, nTrials);
    for t = 1:nTrials; 
        samplesPerCnd(t) = size(cndEyeData{t}.data, 1);
    end
end



