function dotFrames = SingleDot(stmInfo)
    
    dots.x = 0;			
    
    dotShift = mkDotShift(stmInfo)';
    shift.x = repmat(dotShift, [1 size(dots.x, 2)]);
    
    %sign shift: left eye(towards, right) = 1; 
    %sign shift: left eye(away, left) = - 1

    %sign shift: right eye(away, right) = 1; 
    %sign shift: right eye(towards, left) = - 1
    
    where = stmInfo.direction{1};
    Lx = dots.x + directionSigns(where, 'L')*shift.x;	
    Ly = zeros(size(Lx, 1), 1);
    
    Rx = dots.x + directionSigns(where, 'R')*shift.x;	
    Ry = zeros(size(Rx, 1), 1);       
    
    % up-down hack
    if (strcmp(where, 'up') || strcmp(where, 'down'))
       Ly = Lx;
       Lx = zeros(size(Ly, 1), 1);
       Ry = Rx;
       Rx = zeros(size(Ry, 1), 1);
    end
    
    dotFrames.L.x = Lx;
    dotFrames.L.y = Ly;
    dotFrames.R.x = Rx;
    dotFrames.R.y = Ry;
end