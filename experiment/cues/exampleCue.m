function dotFrames = exampleCue(stmInfo)
    % full cue has same dots for each eye
	maxVal = min(stmInfo.xmax, stmInfo.ymax) / 2;
    
    dots.x = ;
    dots.y = ;
    % example: each frame has rand dot positions
    % dots.x = mkRandDots(maxVal, stmInfo.numDots, stmInfo.nFrames);
    % dots.y = zeros(size(dots.x));

    % generate step-ramp type of dot shift 
    % shift is a 1 d vector describing the x-position offset for each frame 
    
    dotShift = mkDotShift(stmInfo);
    shift.x = repmat(dotShift', [1 size(dots.x, 2)]);
   
    
    dotFrames.L = genDotsForOneEye(dots, shift, 'L', stmInfo);
    dotFrames.R = genDotsForOneEye(dots, shift, 'R', stmInfo);        
end