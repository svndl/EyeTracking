function dotFrames = linearDots(stmInfo)
    
	maxVal = min(stmInfo.xmax, stmInfo.ymax) / 2;
    dots.x = repmat(mkRandDots(maxVal, stmInfo.numDots), [1 stmInfo.nFrames]);
    dots.y = zeros(size(dots.x));
    
    dotShift = mkDotShift(stmInfo);
    shift.x = repmat(dotShift', [1 size(dots.x, 2)]);
          
    dotFrames.x = dots.x + stmInfo.shiftSign.*shift.x;	
	dotFrames.y = dots.y;
    
    %limit dot motion to circle
    inScrRadius = dotFrames.x.^2 + dotFrames.y.^2 < stm.stimRadSqPix;	
    dotFrames.x = dotFrames.x.*inScrRadius;
    dotFrames.y = dotFrames.y.*inScrRadius;
end