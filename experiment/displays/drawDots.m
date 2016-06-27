function timing = drawDots(dotFrames, dotColor, dotSize, scr, dotUpdate, noniusLines, msg)
	
    % stimulus step update index, frame index
	idxUpdate   = 1;                         
	idxFrame   = 1;
    
    topPriorityLevel = MaxPriority(scr.wPtr);
    Priority(topPriorityLevel);
    
    t = GetSecs;

    %timing
    waitframes = 0.5;
    vbl = scr.vbl;
    ifi = scr.ifi;
   
    % nonius lines
	line_width  = 2;    
    
    vert_R = scr.fxRadiusY*2;
	vert_W  = line_width*3;    
        
    
    % dot frame is a collection of different dot frames
    % to be displayed at once
    
    nDotFrames = numel(dotFrames);
    % ALL members of dotFrames should have the same number of elements 
    nDotsUpdate = size(dotFrames{1}.L.x, 1);
    
    for ntestFlips = 1:20
        Screen('SelectStereoDrawBuffer', scr.wPtr, 0);
        Screen('SelectStereoDrawBuffer', scr.wPtr, 1);
        Screen('Flip', scr.wPtr);
    end
    trialLoop = tic;
    EyelinkMsg(['StartTrial:' msg]);
        
    %% Real loop
    while(idxUpdate <= nDotsUpdate)    
        % draw dot updates for each frame;
        for r = 1:dotUpdate
            frameLoop = tic; 
            % store eyelink time for the reference 
            timing.eyelink(idxFrame) = EyelinkGetTrackerTime;
            for d = 1:nDotFrames
                
                lDots = [dotFrames{d}.L.x(idxUpdate, :); dotFrames{d}.L.y(idxUpdate, :)];
                rDots = [dotFrames{d}.R.x(idxUpdate, :); dotFrames{d}.R.y(idxUpdate, :)];
			
                scrLCenter = [scr.xc_l scr.yc_l];
                scrRCenter = [scr.xc_r scr.yc_r];
        
                %% draw dots left display
                Screen('SelectStereoDrawBuffer', scr.wPtr, 0);
                Screen('DrawDots', scr.wPtr, lDots, dotSize{d}.L, dotColor{d}.L, scrLCenter, 0);
                if (noniusLines)
                    Screen('FillRect', scr.wPtr, scr.lwhite, ...
                        [scr.xc_l - scr.fxDotRadius scr.yc_l + scr.fxDotRadius ...
                        scr.xc_l + scr.fxDotRadius scr.yc_l + scr.fxDotRadius] );
	
                    Screen('DrawLine', scr.wPtr, scr.lwhite, scr.xc_l, scr.yc_l - vert_R, ...
                        scr.xc_l, scr.yc_l - vert_W, vert_W);
                end
                
                %% draw dots on right display
                Screen('SelectStereoDrawBuffer', scr.wPtr, 1);
                Screen('DrawDots', scr.wPtr, rDots, dotSize{d}.R, dotColor{d}.R, scrRCenter, 0);
                if (noniusLines)
                    Screen('FillRect', scr.wPtr, scr.rwhite, ...
                        [scr.xc_r - scr.fxDotRadius scr.yc_r + scr.fxDotRadius ...
                        scr.xc_r + scr.fxDotRadius scr.yc_r + scr.fxDotRadius] );
	
                    Screen('DrawLine', scr.wPtr, scr.rwhite, scr.xc_r, scr.yc_r + vert_R, ...
                        scr.xc_r, scr.yc_r + vert_W, vert_W);
                end
                
            end
                        
            % determine time for screen flip            
            timing.StimulusReqTime(idxFrame) = t + ((1/scr.frameRate)*(idxFrame - 1));
        
			% flip screen and store timing info for this frame (negative Missed values mean frame was drawn on time)
			[vbl, onsetTime, flipTimeStamp, missed, ~] = Screen('Flip', scr.wPtr, vbl + waitframes*ifi);
            %images(:, :, :, idxUpdate) = rgb2gray(Screen('GetImage', scr.wPtr));
			timing.VBLTimestamp(idxFrame) = vbl;
			timing.StimulusOnsetTime(idxFrame) = onsetTime;
			timing.FlipTimestamp(idxFrame) = flipTimeStamp;
			timing.Missed(idxFrame)  = missed;
			%timing.Beampos(idxFrame) = beampos;
			timing.Ifi(idxFrame) = toc(frameLoop);
			
            idxFrame = idxFrame + 1;       
        end
        idxUpdate = idxUpdate + 1;
    end
    EyelinkMsg(['StopTrial:' msg]);
    timing.trialDuration = toc(trialLoop);    
    Screen('DrawingFinished', scr.wPtr, 0);
    Screen('Flip', scr.wPtr);
end