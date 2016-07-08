function [dotFrames, dotColor, dotSize] = DotFrames(dotParams, videoMode)
    % function will generate dot frames for a given 
    dotParams = calcStimsetParams(dotParams, videoMode);
    dotFrames{1} = feval(dotParams.cues, dotParams);  
    
    colorL = videoMode.lblack;
    colorR = videoMode.rblack;

    if (isfield(dotParams, 'color'))
        colorL = dotParams.color;
        colorR = dotParams.color;
    end
    
    dotColor{1}.L = colorL;
    dotColor{1}.R = colorR;
        
    dotSize{1}.L = dotParams.dotSizePix;
    dotSize{1}.R = dotParams.dotSizePix;
    %eval
end