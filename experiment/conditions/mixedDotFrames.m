function [dotFrames, dotColor, dotSize] = mixedDotFrames(dotParams, videoMode)
    % function will generate dot frames for a given 
    dotParams = calcStimsetParams(dotParams, videoMode);
    
    if (~strcmp(dotParams.cues, 'SingleDot'))
        
        dotParams.numDots = round(0.5*dotParams.numDots);
    
        [dotFrames{1}, dotColor{1}, dotSize{1}] = getHalfDots(dotParams, videoMode.lwhite);
        [dotFrames{2}, dotColor{2}, dotSize{2}] = getHalfDots(dotParams, videoMode.rblack);
    else
        [dotFrames{1}, dotColor{1}, dotSize{1}] = getHalfDots(dotParams, videoMode.lwhite);
    end
end
function [fr, c, sz] = getHalfDots(dotParams, cl)
	fr = feval(dotParams.cues, dotParams);
    sz.L = dotParams.dotSizePix;
    sz.R = dotParams.dotSizePix;
    c.L = cl;
    c.R = cl;
end 