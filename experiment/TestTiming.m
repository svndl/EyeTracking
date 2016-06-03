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
    
    ifiTime = reshape(cat(2, trials.timing(1:end).Ifi), [nFrames stimset.info.nTrials ]);
    vblTime = reshape(cat(2, trials.timing(1:end).VBLTimestamp), [nFrames stimset.info.nTrials ]);
    flipTime = reshape(cat(2, trials.timing(1:end).FlipTimestamp), [nFrames stimset.info.nTrials ]);
    
    ifiPTB = diff(vblTime);
   
    missedTime = reshape(cat(2, trials.timing(1:end).Missed), [nFrames stimset.info.nTrials ]);
    
    close all;
    subplot(3, 1, 1), plot(1:nFrames, ifiTime'), title('Interframe interval calculated'); hold on;
    plot(1:nFrames, 1.2*1/60, '-r', 'LineWidth', 3), hold on;
    plot(1:nFrames, 0.8*1/60, '-r', 'LineWidth', 3), hold on;
    
    subplot(3, 1, 2), hist(round(1000*ifiPTB(:))); title('PTB interframe interval')
    %subplot(3, 1, 2), plot(1:stimset.info.nTrials, sum(missedTime>0)), title('Missed number of frames reported by PTB');hold on;    
    
    %trialDelay = sum(reqTime' - dsplTime');
    
    trialTime = cat(2, trials.timing(1:end).trialDuration);
    subplot(3, 1, 3), plot(1:stimset.info.nTrials, trialTime, '*k'), title('Trial duration, s'); hold on;
    plot(1:stimset.info.nTrials, sum(ifiTime), '*r'), legend('Trial duration reported', 'Trial duration calculated');     
end