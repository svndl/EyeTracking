function timing = drawDots(dotFrames, dotColor, dotSize, scr, dotUpdate, noniusLines, msg)
% Function draws dots and nonius lines, returns timing info. 

% Input variables:

% dotFrames{k}.{L, R}.{x, y}(frameIndex, DotPosition) -- cell array
% with dot coordinates. 
% Every element of cell array stores 
% left & right x&y coordinates describing the motion of a group of dots.
% Example: dotFrames{1}.R.x(1, :) will return x-coordinates for the first
% frame (* x(1, :) *) for the first group of dots (dotFrames{1})
% to be displayed in the right eye.

% All elements of dotFrames will be displayed at once.
% dotSize{k}.{L, R} -- cell array with corresponding dot sizes
% dotColor{k}.{L, R} -- cell array with corresponding dot colors
% scr -- structure with screen info and pointer to PTB window;
% dotUpdate -- dot update rate in Hz;
% noniusLines -- structure with nonius line parameters
% msg -- message sent to Eyelink to mark Start/Stop trial 

% Output variables:

% timing -- structure with timing info (all seconds for each frame);
% timing.VBLTimestamp(1:nFrames) -- VBL timestamp;
% timing.StimulusOnsetTime(1:nFrames) -- stimulus inset time;
% timing.FlipTimestamp(1:nFrames) -- flip timestamp;
% timing.Missed(1:nFrames)  -- distance to req display time (>0 meaning late frame);
% timing.Beampos(1:nFrames) -- beam position for each frame;
% timing.Ifi(1:nFrames) -- tic/toc counter. 


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
                
                % draw nonius & dots left display
                drawStimulus(scr.wPtr, scr.xc_l, scr.yc_l, 'L', ...
                    lDots, dotSize{d}.L, dotColor{d}.L, scrLCenter, noniusLines)        
                % draw nonius & dots right display
                drawStimulus(scr.wPtr, scr.xc_r, scr.yc_r, 'R', ...
                    rDots, dotSize{d}.R, dotColor{d}.R, scrRCenter, noniusLines)
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

function drawStimulus(scrPtr, xc, yc, eye, dots, dotSize, dotColor, scrCenter, nonius)
% drawing dots + nonius on one stereo screen.
% Input: 
% scrPtr -- pointer to PTB Screen;
% [xc, yc] -- nonius line center;
% eye {'L', 'R'}, defines stereo buffer and nonius line shift sign;
% dots -- XY coordinates of dots;
% dotSize -- dot size (applied to all);
% dotColor -- dot color (aplpied to all);
% scrCenter -- [x0 y0] corrdinatess of screen center;
% nonius -- structure with nonius lines settings:
%   nonius.enable [1, 0] -- display nonius lines;
%   nonius.color [0-255] -- nonius line color;  
%   nonius.fxDotRadius [0 ..] -- fixation dot radius, pixels; 
%       (If it's 0, dot is not displayed).
%   nonius.vertW [0..] -- line width, pixels;
%   nonius.vertH [0..] -- line height, pixels;
%   nonius.vertS [0-..] -- vertical shift from 0, pixels. 


    % L/R screen ID
    stereoBufferID = 0;
    signShift = -1;

    if (eye == 'R')
        stereoBufferID = 1;
        signShift = 1;
    end;
       
    Screen('SelectStereoDrawBuffer', scrPtr, stereoBufferID);
    Screen('DrawDots', scrPtr, dots, dotSize, dotColor, ...
        scrCenter, 0);
    % nonius lines
    if (nonius.enable)
        if (nonius.fxDotRadius > 0)
            Screen('FillRect', scrPtr, nonius.color, ...
                [xc - nonius.fxDotRadius yc + nonius.fxDotRadius ...
                xc + nonius.fxDotRadius yc + nonius.fxDotRadius] );
        end
        Screen('DrawLine', scrPtr, nonius.color, xc, ...
            yc + signShift*nonius.vertS, ...
            xc, yc + signShift*(nonius.vertH + nonius.vertS), nonius.vertW);
    end
end