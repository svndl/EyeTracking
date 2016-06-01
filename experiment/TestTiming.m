function testTiming
%% Function will test PTB display timing (trial duration, dropped frames, etc...)  
%% Define dot properties

    displayName = 'LG_OLED_TB';
    displayParams = eval(displayName);
    scr = setupVideoMode(displayParams);
    
    dots = testTiming_dots;
   
    stimset.fhandle = 'DotFrames';
    stimset.fparams = {dots, scr};
    stimset.info = dots;    
    trials = createTrials(stimset.info);
    for t = 1:stimset.info.nTrials
        try 
            [dotFrames, dotColor, dotSize] = feval(stimset.fhandle, stimset.fparams{:});
            dotColor{1}.L = scr.lwhite;
            dotColor{1}.R = scr.rwhite;
            
            dotUpdate = scr.frameRate/stimset.info.dotUpdateHz;
            WaitSecs(.5);
            trials.timing(t) = drawDots(dotFrames, dotColor, dotSize, scr, dotUpdate, stimset.info.nonius);
            WaitSecs(.5);
            display(['done trial ' num2str(t) '/' num2str(stimset.info.nTrials)]);
        catch err
            display('testTiming Error');
            display(err.message);
            display(err.stack(1).file);
            display(err.stack(1).line);
        end
    end
    sca; ListenChar;
    % process trial timing
    
    nFrames = size(dotFrames{1}.L.x, 1);
    
    reqTime = reshape(cat(2, trials.timing(1:end).StimulusReqTime), [stimset.info.nTrials nFrames]);
    dsplTime = reshape(cat(2, trials.timing(1:end).StimulusOnsetTime), [stimset.info.nTrials nFrames]);
    ifiTime = reshape(cat(2, trials.timing(1:end).Ifi), [stimset.info.nTrials nFrames]);
    subplot(4, 1, 1), plot(1:nFrames, [reqTime; dsplTime]), title('Req and actual Dspl time');
    
    subplot(4, 1, 2), plot(1:nFrames, diff(dsplTime - reqTime)), title('Frame difference interval');
    
    subplot(4, 1, 3), plot(1:nFrames, ifiTime), title('Interframe interval');
    
    %trialDelay = sum(reqTime' - dsplTime');
    
    trialTime = cat(2, trials.timing(1:end).trialDuration);
    subplot(4, 1, 4), plot(1:stimset.info.nTrials, trialTime, '*k'), title('Trial duration, s');
end