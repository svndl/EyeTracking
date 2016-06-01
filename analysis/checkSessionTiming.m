function lateFrames = checkSessionTiming(sessionData)
    
    %% load session matfile
    %% for each conditions, get frame display statistic 
    
    nCnd = numel(sessionData);
    lateFrames = cell(nCnd, 1);
    for nc = 1:nCnd
        cndTiming = sessionData{nc}.timing;
        lateFrames{nc} = checkCndTiming(cndTiming);
    end
end
function lateFrames = checkCndTiming(cndTiming)
    nTrials = numel(cndTiming);
    nFrames = size(cndTiming(1).StimulusReqTime, 2);
    reqTime = reshape(cat(2, cndTiming(1:end).StimulusReqTime), [nTrials nFrames]);
    dsplTime = reshape(cat(2, cndTiming(1:end).StimulusOnsetTime), [nTrials nFrames]);
    % concatenate trial timing into one matrix
    ifiReq = diff(reqTime');
    ifiDspl = diff(dsplTime');
    lateFrames = sum(ifiDspl> 1.2*mean(ifiReq(:)));    
end
