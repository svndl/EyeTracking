function stm = stimulus_draw_trial(w, trial, dotsLE, dotsRE, dat, stm, scr, condition, dynamics, direction, delay)
%
% draw dynamic part of trial

t = GetSecs;

uind   = 1;                         % stimulus step update index
fidx   = 1;							% frame index
while(uind <= size(dotsLE,2))       % while there are still updates
    
    % draw dot updates for each frame
    for r = 1:stm.dotRepeats
        
        % draw fixation pattern with stimulus
        if dat.nonius
            stimulus_draw_fixation(w, scr, stm, 0);                  
        end
        
        % update dots
        Screen('DrawDots', w, dotsLE{uind}, stm.dotSizePix, scr.LEwhite, [scr.x_center_pix_left  scr.y_center_pix_left], 0);
        Screen('DrawDots', w, dotsRE{uind}, stm.dotSizePix, scr.REwhite, [scr.x_center_pix_right scr.y_center_pix_right], 0);
        
        % determine time for screen flip
        stm.trials.StimulusReqTime{trial}(fidx) = t + ((1/scr.frameRate)*(fidx - 1));
        
        % flip screen and store timing info for this frame (negative Missed values mean frame was drawn on time)
		
		[timeStamp, onsetTime, flipTimeStamp, missed, beampos] = Screen('Flip', w, stm.trials.StimulusReqTime{trial}(fidx));
        
		stm.trials.VBLTimestamp{trial}(fidx) = timeStamp;
		stm.trials.StimulusOnsetTime{trial}(fidx) = onsetTime;
		stm.trials.FlipTimestamp{trial}(fidx) = flipTimeStamp;
		stm.trials.Missed{trial}(fidx)  = missed;
		stm.trials.Beampos{trial}(fidx) = beampos;
        
        fidx = fidx + 1;
        
    end
    
    if uind == delay                    
        
        tStart  = GetSecs;
		if (dat.recording)
			eyelink_start_recording(dat, condition, dynamics, direction, trial) 
		end
    end
    
    uind = uind + 1;        
    
end

% stop recording
if (dat.recording)
	eyelink_end_recording(condition,dynamics,direction,trial)
end

% store trial timing info
stm.trials.durationSec(trial) = GetSecs - tStart;

% report to experimenter about trial timing
display(['Trial duration was ' num2str(1000*(stm.trials.durationSec(trial) - (dat.preludeSec + dat.cycleSec)),3) ' ms over']); 

