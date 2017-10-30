function dotFrames = FullCue(stmInfo)
    % full cue has same dots for each eye
	maxVal = min(stmInfo.xmax, stmInfo.ymax);
    %each frame has rand dot positions
    
    dots.x = repmat(mkRandDots(maxVal, stmInfo.numDots), [stmInfo.nFrames 1]);
    dots.y = repmat(mkRandDots(maxVal, stmInfo.numDots), [stmInfo.nFrames 1]);

    dotShift = mkDotShift(stmInfo);
    shift.x = repmat(dotShift', [1 size(dots.x, 2)]);
    dotFrames.L = genDotsForOneEye(dots, shift, 'L', stmInfo);
    dotFrames.R = genDotsForOneEye(dots, shift, 'R', stmInfo);        
end