function timing = drawTrial(trialNum, dotsLE, dotsRE, stm, scr, isSaltPepper)
% draw dynamic part of trial simultaneously record

    % timing control
    
    
    tStart = GetSecs;
	
    if(stm.recording)
        EyelinkMsgStart(stm, trialNum); 
    end
    
    if(~isSaltPepper)
        timing = drawBW(dotsLE, dotsRE, stm, scr);
    else
       timing = drawSP(dotsLE, dotsRE, stm, scr);
    end
 	% stop recording
	if (stm.recording)
		EyelinkMsgStop(stm, trialNum);
	end

	% store trial timing info
	timing.durationSec(trialNum) = GetSecs - tStart;

	% report to experimenter about trial timing
	display(['Trial duration was ' num2str(1e+03*(timing.durationSec(trialNum) - (stm.preludeSec + stm.cycleSec)), 3) ' ms over']); 
end


function timing = drawBW(dotsLE, dotsRE, stm, scr)
	
    % stimulus step update index, frame index
	idxUpdate   = 1;                         
	idxFrame   = 1;
	
    t = GetSecs;

    %timing
    waitframes = 1;
    vbl = Screen('Flip', scr.wPrt);
    ifi = Screen('GetFlipInterval', scr.wPrt);
    
    
    while(idxUpdate <= size(dotsLE.x, 1))
        % draw dot updates for each frame;
        for r = 1:stm.dotRepeats
            % draw fixation pattern with stimulus
            
            if stm.nonius
				drawFixation(scr, stm, 0);                  
			end
			
			lDots = [dotsLE.x(idxUpdate, :); dotsLE.y(idxUpdate, :)];
			rDots = [dotsRE.x(idxUpdate, :); dotsRE.y(idxUpdate, :)];
			
			scrLCenter = [scr.xc_l scr.yc_l];
			scrRCenter = [scr.xc_r scr.yc_r];
        
			% update dots
			Screen('DrawDots', scr.wPrt, lDots, stm.dotSizePix, scr.lwhite, scrLCenter, 0);
			Screen('DrawDots', scr.wPrt, rDots, stm.dotSizePix, scr.rwhite, scrRCenter, 0);
        
			% determine time for screen flip
			timing.StimulusReqTime(idxFrame) = t + ((1/scr.frameRate)*(idxFrame - 1));
        
			% flip screen and store timing info for this frame (negative Missed values mean frame was drawn on time)

			[vbl, onsetTime, flipTimeStamp, missed, beampos] = Screen('Flip', scr.wPrt, vbl + (waitframes - 0.5) * ifi);
        
			timing.VBLTimestamp(idxFrame) = vbl;
			timing.StimulusOnsetTime(idxFrame) = onsetTime;
			timing.FlipTimestamp(idxFrame) = flipTimeStamp;
			timing.Missed(idxFrame)  = missed;
			timing.Beampos(idxFrame) = beampos;
        
			idxFrame = idxFrame + 1;       
        end
        idxUpdate = idxUpdate + 1;
    end

end

function timing = drawSP(dotsLE, dotsRE, stm, scr)
	
    % stimulus step update index, frame index
	idxUpdate   = 1;                         
	idxFrame   = 1;
	
    t = GetSecs;

    %timing
    waitframes = 1;
    vbl = Screen('Flip', scr.wPtr);
    ifi = Screen('GetFlipInterval', scr.wPtr);
    
    %% split the dots into S&P dots
    [salt, pepper] = splitToSaltPepper(dotsLE, dotsRE, stm);
    
    while(idxUpdate <= size(dotsLE.x,1))
        % draw dot updates for each frame
        if (~stm.dotRepeats)
            stm.dotRepeats = round(60/stm.dotUpdateHz);
        end
        for r = 1:stm.dotRepeats
            % draw fixation pattern with stimulus
			if stm.nonius
				drawFixation(scr, stm, 0);                  
			end
			
			lSaltDots = [salt.L.x(idxUpdate, :); salt.L.y(idxUpdate, :)];
			rSaltDots = [salt.R.x(idxUpdate, :); salt.R.y(idxUpdate, :)];

            lPepperDots = [pepper.L.x(idxUpdate, :); pepper.L.y(idxUpdate, :)];
			rPepperDots = [pepper.R.x(idxUpdate, :); pepper.R.y(idxUpdate, :)];
			
			scrLCenter = [scr.x_center_pix_left  scr.y_center_pix_left];
			scrRCenter = [scr.x_center_pix_right scr.y_center_pix_right];
			
            %draw salt
            Screen('DrawDots', scr.wPtr, lSaltDots, stm.dotSizePix, scr.LEwhite, scrLCenter, 0);
			Screen('DrawDots', scr.wPtr, rSaltDots, stm.dotSizePix, scr.REwhite, scrRCenter, 0);
        
            % draw pepper
            ScreenDrawDots(scr.wPtr, lPepperDots, stm.dotSizePix, [0 0 0], scrLCenter, 1);
			ScreenDrawDots(scr.wPtr, rPepperDots, stm.dotSizePix, [0 0 0], scrRCenter, 1);
           
			% determine time for screen flip
			timing.StimulusReqTime(idxFrame) = t + ((1/scr.frameRate)*(idxFrame - 1));
        
			% flip screen and store timing info for this frame (negative Missed values mean frame was drawn on time)

			[vbl, onsetTime, flipTimeStamp, missed, beampos] = Screen('Flip', scr.wPtr, vbl + (waitframes - 0.5) * ifi);
        
			timing.VBLTimestamp(idxFrame) = vbl;
			timing.StimulusOnsetTime(idxFrame) = onsetTime;
			timing.FlipTimestamp(idxFrame) = flipTimeStamp;
			timing.Missed(idxFrame)  = missed;
			timing.Beampos(idxFrame) = beampos;
        
			idxFrame = idxFrame + 1;       
        end
        idxUpdate = idxUpdate + 1;
    end

end

function [salt, pepper] = splitToSaltPepper(dotsL, dotsR, stm)

    halfdots = round(0.5*size(dotsR.x, 2));
    switch char(stm.condition)
        case{'CDOT', 'FullCue'}
        
            salt.L.x = dotsL.x(:, 1:halfdots);
            salt.L.y = dotsL.y(:, 1:halfdots);
            salt.R.x = dotsR.x(:, 1:halfdots);
            salt.R.y = dotsR.y(:, 1:halfdots);
        
            pepper.L.x = dotsL.x(:, halfdots + 1:end);
            pepper.L.y = dotsL.y(:, halfdots + 1:end);
            pepper.R.x = dotsR.x(:, halfdots + 1:end);
            pepper.R.y = dotsR.y(:, halfdots + 1:end);
    
        case{'IOVD'}
        
            salt.L.x = dotsL.x(:, 1:halfdots);
            salt.L.y = dotsL.y(:, 1:halfdots);
            salt.R.x = dotsR.x(:, 1:halfdots);
            salt.R.y = dotsR.y(:, 1:halfdots);
        
            pepper.L.x = dotsL.x(:, halfdots + 1:end);
            pepper.L.y = dotsL.y(:, halfdots + 1:end);
            pepper.R.x = dotsR.x(:, halfdots + 1:end);
            pepper.R.y = dotsR.y(:, halfdots + 1:end); 
    end
end


