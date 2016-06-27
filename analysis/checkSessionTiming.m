function lateFrames = checkSessionTiming(sessionData, plotTiming)
    
    %% load session matfile
    %% for each conditions, get frame display statistic 
    nCnd = numel(sessionData);
    lateFrames = cell(nCnd, 1);
    for nc = 1:nCnd
        cndTiming = sessionData{nc}.timing;
        dotUpdateHz = sessionData{nc}.info.dotUpdateHz;
        cndEyeData = sessionData{nc}.data;
        [ifiPTB, lateFrames{nc}] = checkCndTiming(cndTiming, dotUpdateHz);
        if(plotTiming)
            ylim([0.8*1000/dotUpdateHz 1.5*1000/dotUpdateHz]);
            subplot(nCnd, 1, nc), plot(ifiPTB), title(['Interframe interval condition' num2str(nc)]); hold on;
            plot(1:size(ifiPTB, 1), 1.1*1000/dotUpdateHz, '-r*'); hold on;
        end
        samplesPerCnd = checkEyelinkData(cndEyeData);
        disp([ 'Condition ' num2str(nc) '  missed Frames :' num2str(lateFrames{nc})]);
        disp([ 'Condition ' num2str(nc) '  Eyelink samples :' num2str(samplesPerCnd)]);
        
        %eyelink Trial Data
    end
end
function [ifiPTB, lateFrames] = checkCndTiming(cndTiming, dotUpdateHz)
    nTrials = numel(cndTiming);
    nFrames = size(cndTiming(1).StimulusReqTime, 2);
%     reqTime = reshape(cat(2, cndTiming(1:end).StimulusReqTime), [nFrames nTrials]);
%     dsplTime = reshape(cat(2, cndTiming(1:end).StimulusOnsetTime), [nFrames nTrials]);
    vblTime = reshape(cat(2, cndTiming(1:end).VBLTimestamp), [nFrames nTrials]);
    missed = reshape(cat(2, cndTiming(1:end).Missed), [nFrames nTrials]);
    ifiPTB = (1000*diff(vblTime));   
    lateFrames = sum((ifiPTB > 1.1*1000/dotUpdateHz));
    missedFrames = sum(missed>0)
end
function samplesPerCnd = checkEyelinkData(cndEyeData)
    nTrials = numel(cndEyeData);
    samplesPerCnd = zeros(1, nTrials);
    for t = 1:nTrials; 
        samplesPerCnd(t) = size(cndEyeData{t}.data, 1);
    end
end



