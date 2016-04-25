function [dotFrames, dotColor, dotSize] = antiCorrDotFrames(dotParams, videoMode)
    % function will generate dot frames for a given 
    dotParams = calcStimsetParams(dotParams, videoMode);
    
    if (~strcmp(dotParams.cues, 'SingleDot'))
        
        dotParams.numDots = round(0.25*dotParams.numDots);
        % correlated (same color each eye s& p) 
        [dotFrames{1}, dotColor{1}, dotSize{1}] = getDots(dotParams, videoMode.lwhite, videoMode.rwhite);
        [dotFrames{2}, dotColor{2}, dotSize{2}] = getDots(dotParams, videoMode.lblack, videoMode.rblack);
        
        % anti-correlated (different color each eye s&p) 
        [dotFrames{3}, dotColor{3}, dotSize{3}] = getDots(dotParams, videoMode.lwhite, videoMode.rblack);
        [dotFrames{4}, dotColor{4}, dotSize{4}] = getDots(dotParams, videoMode.lblack, videoMode.rwhite);
        %
    else
        [dotFrames{1}, dotColor{1}, dotSize{1}] = getDots(dotParams, videoMode.lblack, videoMode.rblack);
    end
end
function [fr, c, sz] = getDots(dotParams, cL, cR)
	fr = feval(dotParams.cues, dotParams);
    sz.L = dotParams.dotSizePix;
    sz.R = dotParams.dotSizePix;
    c.L = cL;
    c.R = cR;    
end 