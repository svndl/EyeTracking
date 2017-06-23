function framesOut = generatePrelude(dotFrames, conditionInfo)

    preludeDurationFrames = conditionInfo.preludeSec*conditionInfo.dotUpdateHz;
    nDotStructs = numel(dotFrames);
    if ~(isfield(conditionInfo, 'preludeType'))
        pt = 'none';
    else
        pt = conditionInfo.preludeType;
    end
    
    switch pt
        case 'none'
            % nothing is changed 
%             for n = 1:nDotStructs
%                 dotFrames{n}.L.x(1:preludeDurationFrames, :) = 0;
%                 dotFrames{n}.L.y(1:preludeDurationFrames, :) = 0;
%                 dotFrames{n}.R.x(1:preludeDurationFrames, :) = 0;
%                 dotFrames{n}.R.y(1:preludeDurationFrames, :) = 0;               
%             end
        case 'static'
            for n = 1:nDotStructs
                %display same frame in L& R eyes
                firstFrameX = repmat(dotFrames{n}.L.x(1, :),  [preludeDurationFrames 1]);
                firstFrameY = repmat(dotFrames{n}.L.y(1, :),  [preludeDurationFrames 1]);
                
                dotFrames{n}.L.x(1:preludeDurationFrames, :) = firstFrameX;
                dotFrames{n}.L.y(1:preludeDurationFrames, :) = firstFrameY;
                dotFrames{n}.R.x(1:preludeDurationFrames, :) = firstFrameX;
                dotFrames{n}.R.y(1:preludeDurationFrames, :) = firstFrameY;               
            end
        case 'dynamic'
            for n = 1:nDotStructs            
                dotFrames{n}.L.x(1:preludeDurationFrames, :) = ...
                    dotFrames{n}.R.x(1:preludeDurationFrames, :);
                dotFrames{n}.L.y(1:preludeDurationFrames, :) = ...
                    dotFrames{n}.R.y(1:preludeDurationFrames, :);
            end
    end
    framesOut = dotFrames;
    
end