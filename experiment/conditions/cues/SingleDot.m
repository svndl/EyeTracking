function dotFrames = SingleDot(stmInfo)
    
    dots.x = 0;			
    
    dotShift = mkDotShift(stmInfo)';
    shift.x = repmat(dotShift, [1 size(dots.x, 2)]);
    
    %sign shift: left eye(towards, right) = 1; 
    %sign shift: left eye(away, left) = - 1

    %sign shift: right eye(away, right) = 1; 
    %sign shift: right eye(towards, left) = - 1
    
    dotFrames.L.x = dots.x + directionSigns(stmInfo.direction{1}, 'L')*shift.x;	
	dotFrames.L.y = zeros(size(dotFrames.L.x, 1), 1);
    
    dotFrames.R.x = dots.x + directionSigns(stmInfo.direction{1}, 'R')*shift.x;	
	dotFrames.R.y = zeros(size(dotFrames.R.x, 1), 1);
    
end