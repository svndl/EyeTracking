function dotFrames = IOVD(stmInfo)
    %different dots in each eye
	maxVal = min(stmInfo.xmax, stmInfo.ymax) / 2;
    dots1.x = repmat(mkRandDots(maxVal, stmInfo.numDots), [stmInfo.nFrames + numel(stmInfo.prelude) 1]);
    dots1.y = repmat(mkRandDots(maxVal, stmInfo.numDots), [stmInfo.nFrames + numel(stmInfo.prelude) 1]);
    
    dots2.x = repmat(mkRandDots(maxVal, stmInfo.numDots), [stmInfo.nFrames + numel(stmInfo.prelude) 1]);
    dots2.y = repmat(mkRandDots(maxVal, stmInfo.numDots), [stmInfo.nFrames + numel(stmInfo.prelude) 1]);

    dotShift = mkDotShift(stmInfo);
    shift.x = repmat(dotShift', [1 size(dots1.x, 2)]);

    dotFrames.L = genDotsForOneEye(dots1, shift, 'L', stmInfo);
    dotFrames.R = genDotsForOneEye(dots2, shift, 'R', stmInfo);        
end



