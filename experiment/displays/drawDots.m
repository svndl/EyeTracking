function timing = drawDots(dotFrames, dotColor, dotSize, scr, dotUpdate)
	
    % stimulus step update index, frame index
	idxUpdate   = 1;                         
	idxFrame   = 1;
    
    topPriorityLevel = MaxPriority(scr.wPtr);
    Priority(topPriorityLevel);
    
    t = GetSecs;

    %timing
    waitframes = 1;
    
    nFlips = 10;
    vbl_k = zeros(nFlips, 1);
    ifi_k = zeros(nFlips, 1);
    
    for k = 1:nFlips
        vbl_k(k) = Screen('Flip', scr.wPtr);
        ifi_k(k) = Screen('GetFlipInterval', scr.wPtr);
    end
    vbl = mean(vbl_k);
    ifi = mean(ifi_k);
    % dot frame is a collection of different dot frames
    % to be displayed at once
    
    nDotFrames = numel(dotFrames);
    % ALL members of dotFrames should have the same number of elements 
    
    nDotsUpdate = size(dotFrames{1}.L.x, 1);
    
    while(idxUpdate <= nDotsUpdate)
        % draw dot updates for each frame;
        for r = 1:dotUpdate
            % draw fixation pattern with stimulus
            drawFixation(scr, 0, 0);
            drawFixation(scr, 0, 1);
            
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

               % flickering giant white dot
            end
            
%             if (rem(idxUpdate, 2))
%                 Screen('SelectStereoDrawBuffer', scr.wPtr, 0);
%                 % Now draw our left eyes dots
%                 Screen('DrawDots', scr.wPtr, [20, 20], 50, scr.rwhite, scrLCenter - 500, 2);
% 
%                 % Select right-eye image buffer for drawing (buffer = 1)
%                 Screen('SelectStereoDrawBuffer', scr.wPtr, 1);
% 
%                 % Now draw our right eyes dots
%                 Screen('DrawDots', scr.wPtr, [20, 20], 50, scr.rwhite, scrRCenter - 500, 2);
%             end
            
            % determine time for screen flip            
            timing.StimulusReqTime(idxFrame) = t + ((1/scr.frameRate)*(idxFrame - 1));
        
			% flip screen and store timing info for this frame (negative Missed values mean frame was drawn on time)
            %imageArray(idxUpdate, :, :, :) = img;
			[vbl, onsetTime, flipTimeStamp, missed, beampos] = Screen('Flip', scr.wPtr, vbl + (waitframes - 0.5) * ifi);
            %img = Screen('GetImage', scr.wPtr);
            %save(strcat('img', num2str(idxUpdate), '.mat'), 'img');
        
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