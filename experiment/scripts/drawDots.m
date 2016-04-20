function timing = drawDots(dotFrames, dotColor, dotSize, scr)
	
    % stimulus step update index, frame index
	idxUpdate   = 1;                         
	idxFrame   = 1;
	
    t = GetSecs;
    topPriorityLevel = MaxPriority(scr.wPtr);
    Priority(topPriorityLevel);

    %timing
    waitframes = 1;
    vbl = Screen('Flip', scr.wPtr);
    ifi = Screen('GetFlipInterval', scr.wPtr);
    
    % dot frame is a collection of different dot frames
    % to be displayed at once
    
    nDotFrames = numel(dotFrames);
    % ALL members of dotFrames should have the same number of elements 
    
    nDotsUpdate = size(dotFrames{1}.L.x, 1);
    
    while(idxUpdate <= nDotsUpdate)
        % draw dot updates for each frame;
        dotRepeats = 1;
        for r = 1:dotRepeats
            % draw fixation pattern with stimulus
            drawFixation(scr, 0);                 
            %if (stm.nonius)
			%	drawFixation(scr, 0);                  
            %end
			
            for d = 1:nDotFrames
                
                lDots = [dotFrames{d}.L.x(idxUpdate, :); dotFrames{d}.L.y(idxUpdate, :)];
                rDots = [dotFrames{d}.R.x(idxUpdate, :); dotFrames{d}.R.y(idxUpdate, :)];
			
                scrLCenter = [scr.xc_l scr.yc_l];
                scrRCenter = [scr.xc_r scr.yc_r];
        
                % update left & right dots 
                % Select left-eye image buffer for drawing (buffer = 0)
                Screen('SelectStereoDrawBuffer', scr.wPtr, 0);
                % Now draw our left eyes dots
                Screen('DrawDots', scr.wPtr, lDots, dotSize{d}.L, dotColor{d}.L, scrLCenter, 0);

                % Select right-eye image buffer for drawing (buffer = 1)
                Screen('SelectStereoDrawBuffer', scr.wPtr, 1);

                % Now draw our right eyes dots
                Screen('DrawDots', scr.wPtr, rDots, dotSize{d}.R, dotColor{d}.R, scrRCenter, 0);

%                 Screen('DrawDots', scr.wPtr, lDots, dotSize{d}.L, dotColor{d}.L, scrLCenter, 0);
%                 Screen('DrawDots', scr.wPtr, rDots, dotSize{d}.R, dotColor{d}.R, scrRCenter, 0);
            end
            
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