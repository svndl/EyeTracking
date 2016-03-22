function timing = drawTrial(w, trialNum, dotsLE, dotsRE, stm, scr, delay)
% draw dynamic part of trial simultaneously record

    % timing control
    waitframes = 1;
    vbl = Screen('Flip', w);
    ifi = Screen('GetFlipInterval', w);
    
	t = GetSecs;
	% stimulus step update index
	uind   = 1;                         
	%frame index
	fidx   = 1;							
	while(uind <= size(dotsLE.x,1))       
    
		% draw dot updates for each frame
		for r = 1:stm.dotRepeats
        
			% draw fixation pattern with stimulus
			if stm.nonius
				drawFixation(w, scr, stm, 0);                  
			end
			
			lDots = [dotsLE.x(uind); dotsLE.y(uind)];
			rDots = [dotsRE.x(uind); dotsRE.y(uind)];
			
			scrLCenter = [scr.x_center_pix_left  scr.y_center_pix_left];
			scrRCenter = [scr.x_center_pix_right scr.y_center_pix_right];
        
			% update dots
			Screen('DrawDots', w, lDots, stm.dotSizePix, scr.LEwhite, scrLCenter, 0);
			Screen('DrawDots', w, rDots, stm.dotSizePix, scr.REwhite, scrRCenter, 0);
        
			% determine time for screen flip
			timing.StimulusReqTime(fidx) = t + ((1/scr.frameRate)*(fidx - 1));
        
			% flip screen and store timing info for this frame (negative Missed values mean frame was drawn on time)

			[vbl, onsetTime, flipTimeStamp, missed, beampos] = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
        
			timing.VBLTimestamp(fidx) = vbl;
			timing.StimulusOnsetTime(fidx) = onsetTime;
			timing.FlipTimestamp(fidx) = flipTimeStamp;
			timing.Missed(fidx)  = missed;
			timing.Beampos(fidx) = beampos;
        
			fidx = fidx + 1;
		end
		if uind == delay
            display('Reached delay');
			tStart  = GetSecs;
			if (stm.recording)
				EyelinkMsgStart(stm, trialNum); 
			end
		end
    
		uind = uind + 1;        
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
