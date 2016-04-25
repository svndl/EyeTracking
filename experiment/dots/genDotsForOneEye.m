function dots = genDotsForOneEye(startPos, shift, eye, stm)
    dots.x = startPos.x + directionSigns(stm.direction, eye)*shift.x;	
	dots.y = startPos.y;
    
    %limit dot motion to circle
    inScrRadius = dots.x.^2 + dots.y.^2 < stm.stimRadSqPix;	
    dots.x = dots.x.*inScrRadius;
    dots.y = dots.y.*inScrRadius;
end