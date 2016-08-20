function dataOut = loadSession(pathToSession)
    
    display(['Loading... ' pathToSession]);
    
    processedData = processRawData(pathToSession);
    
    
    nCnd = numel(processedData);
    dataOut = cell(nCnd, 1);
    
    for c = 1:nCnd;
        try
            cnd = processedData{c};
            % remove prelude
            nSamples = uint32(1000*cnd.info.cycleSec);
            %wrong for dotUpdateHz < 60 Hz
            nFrames = uint32(cnd.info.cycleSec*cnd.info.dotUpdateHz);
            % pos
            L = startAtZero(takeLastN(cnd.pos.L, nSamples));
            R = startAtZero(takeLastN(cnd.pos.R, nSamples));
            % vel
            Lv = startAtZero(takeLastN(cnd.vel.L, nSamples));
            Rv = startAtZero(takeLastN(cnd.vel.R, nSamples));

            timing = removePreludeData(cnd.timing, nFrames);                
        
            isTrialOK = rejectBadTrials(timing); 
                        
            dataOut{c}.pos.L = filterData(L(:, :, isTrialOK));
            dataOut{c}.pos.R = filterData(R(:, :, isTrialOK));
        
            dataOut{c}.vel.L = filterData(Lv(:, :, isTrialOK));
            dataOut{c}.vel.R = filterData(Rv(:, :, isTrialOK));
        
            dataOut{c}.timecourse = takeLastN(cnd.timecourse', nSamples);
        
        
            dataOut{c}.info = cnd.info;
            dataOut{c}.response = cnd.response(isTrialOK);
       
            display(['Cnd ' num2str(c) ': Trials L' num2str(sum(isTrialOK)) ...
            '/' num2str(cnd.info.nTrials)]);
            display(['Cnd ' num2str(c) ': Trials R' num2str(sum(isTrialOK)) ...
            '/' num2str(cnd.info.nTrials)]);
        
        catch err
            display(['Error processing the raw data cnd ' num2str(c)]);
            display(err.message);            
            for e = 1: numel(err.stack)
                display(err.stack(e).file);
                display(err.stack(e).line);
            end
            dataOut{c} = {};
        end
    end
end
function t = removePreludeData(data, nSamples)
    t = cellfun(@(x) takeLastN(x, nSamples), data, 'UniformOutput', false);
end