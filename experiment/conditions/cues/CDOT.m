function dotFrames = CDOT(stmInfo)
    % full cue has same dots for each eye
	maxVal = min(stmInfo.xmax, stmInfo.ymax);
    %each frame has rand dot positions
    dots.x = mkRandDots(maxVal, stmInfo.numDots, stmInfo.nFrames + numel(stmInfo.prelude));
    dots.y = mkRandDots(maxVal, stmInfo.numDots, stmInfo.nFrames + numel(stmInfo.prelude));

    dotShift = mkDotShift(stmInfo);
    shift.x = repmat(dotShift', [1 size(dots.x, 2)]);    
    
    %zeroShift.x = zeros(size(shift.x));
    dotFrames.L = genDotsForOneEye(dots, shift, 'L', stmInfo);
    dotFrames.R = genDotsForOneEye(dots, shift, 'R', stmInfo);        
end