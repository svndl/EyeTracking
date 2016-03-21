function trials = runTrial(w, trialNum, dotsLE, dotsRE, stm, scr, condition, dynamics, direction, delay)
% draw dynamic part of trial
% simultaneously record

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
			trials.StimulusReqTime{trialNum}(fidx) = t + ((1/scr.frameRate)*(fidx - 1));
        
			% flip screen and store timing info for this frame (negative Missed values mean frame was drawn on time)
		
			[timeStamp, onsetTime, flipTimeStamp, missed, beampos] = Screen('Flip', w, trials.StimulusReqTime{trialNum}(fidx));
        
			trials.VBLTimestamp(trialNum, fidx) = timeStamp;
			trials.StimulusOnsetTime(trialNum, fidx) = onsetTime;
			trials.FlipTimestamp(trialNum, fidx) = flipTimeStamp;
			trials.Missed(trialNum, fidx)  = missed;
			trials.Beampos(trialNum, fidx) = beampos;
        
			fidx = fidx + 1;
		end
		if uind == delay
        
			tStart  = GetSecs;
			if (stm.recording)
				EyelinkStartRecord(stm, condition, dynamics, direction, trialNum) 
			end
		end
    
		uind = uind + 1;        
	end

	% stop recording
	if (stm.recording)
		EyelinkStopRecord(condition, dynamics, direction, trialNum)
	end

	% store trial timing info
	trials.durationSec(trialNum) = GetSecs - tStart;

	% report to experimenter about trial timing
	display(['Trial duration was ' num2str(1000*(stm.trials.durationSec(trialNum) - (dat.preludeSec + dat.cycleSec)),3) ' ms over']); 
end
