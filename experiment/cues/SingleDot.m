function dotFrames = SingleDot(stmInfo)

        
    dots.x = zeros(stmInfo.nFrames, 1);			
    dots.y = zeros(size(dots.x));
    
    dotShift = mkDotShift(stmInfo)';
    shift.x = repmat(dotShift, [1 size(dots.x, 2)]);
    
    %sign shift: left eye(towards, right) = 1; 
    %sign shift: left eye(away, left) = - 1

    %sign shift: right eye(away, right) = 1; 
    %sign shift: right eye(towards, left) = - 1
    
    dotFrames.x = dots.x + stmInfo.shiftSign*shift.x;	
	dotFrames.y = dots.y;
    
end