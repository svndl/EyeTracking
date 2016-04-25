function dots = mkDotFrames(dotParams, eye)
    % function will generate dot frames for a given 
        
    dotParams.shiftSign = directionSigns(dotParams.direction{1}, eye);
    dots = feval(dotParams.cues, dotParams);  
end