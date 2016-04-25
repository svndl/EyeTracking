function [dotFrames, dotColor, dotSize] = DotFrames(dotParams, videoMode)
    % function will generate dot frames for a given 
    dotParams = calcStimsetParams(dotParams, videoMode);
    dotFrames{1} = feval(dotParams.cues, dotParams);  
    
    dotColor{1}.L = videoMode.lblack;
    dotColor{1}.R = videoMode.rblack;
    
    dotSize{1}.L = dotParams.dotSizePix;
    dotSize{1}.R = dotParams.dotSizePix;
    %eval
end