function framesOut = generatePrelude(dotFrames, conditionInfo)

    preludeDurationFrames = conditionInfo.preludeSec*conditionInfo.dotUpdateHz;
    nDotStructs = numel(dotFrames);
    if ~(isfield(conditionInfo, 'preludeType'))
        pt = 'none';
    else
        pt = conditionInfo.preludeType;
    end
    
    if ~(isfield(conditionInfo, 'waitAfterPrelude'))
        w = .1;
    else
        w = conditionInfo.waitAfterPrelude;
    end
    
    waitAfterPreludeFrames = w*conditionInfo.dotUpdateHz;
    
    switch pt
        case 'empty'
            %% display empty preludeDurationFrames frames in L&R eyes                        
            for n = 1:nDotStructs                
                dotFrames{n}.L.x(1:preludeDurationFrames, :) = NaN;
                dotFrames{n}.L.y(1:preludeDurationFrames, :) = NaN;
                dotFrames{n}.R.x(1:preludeDurationFrames, :) = NaN;
                dotFrames{n}.R.y(1:preludeDurationFrames, :) = NaN;
                
            end

        case 'static'
            %% display same first frame in L&R eyes            
            for n = 1:nDotStructs
                firstFrameX = repmat(dotFrames{n}.L.x(1, :),  [preludeDurationFrames 1]);
                firstFrameY = repmat(dotFrames{n}.L.y(1, :),  [preludeDurationFrames 1]);
                
                dotFrames{n}.L.x(1:preludeDurationFrames, :) = firstFrameX;
                dotFrames{n}.L.y(1:preludeDurationFrames, :) = firstFrameY;
                dotFrames{n}.R.x(1:preludeDurationFrames, :) = firstFrameX;
                dotFrames{n}.R.y(1:preludeDurationFrames, :) = firstFrameY;
                
            end
        case 'dynamic'
            %% display same preludeDurationFrames frames in L&R eyes            
            for n = 1:nDotStructs            
                dotFrames{n}.L.x(1:preludeDurationFrames, :) = ...
                    dotFrames{n}.R.x(1:preludeDurationFrames, :);
                dotFrames{n}.L.y(1:preludeDurationFrames, :) = ...
                    dotFrames{n}.R.y(1:preludeDurationFrames, :);
                
            end
    end
    framesOut = dotFrames;
    
    if (w > 0)
        for n = 1:nDotStructs
            framesOut{n} = mkGapFrames(dotFrames{n}, preludeDurationFrames, waitAfterPreludeFrames);
        end
    end
end
%% Wait Frames
function out = mkGapFrames(dotFrames, preludeDurationFrames, waitAfterPreludeFrames)
    nLeftDots = size(dotFrames.L.x, 2);
    nRightDots = size(dotFrames.R.x, 2);

    gapFramesL = NaN*ones(waitAfterPreludeFrames, nLeftDots);
    gapFramesR = NaN*ones(waitAfterPreludeFrames, nRightDots);
    
    
    out.L.x = cat(1, dotFrames.L.x(1:preludeDurationFrames, :), gapFramesL, ...
        dotFrames.L.x(1 + preludeDurationFrames:end, :));  
    out.L.y = cat(1, dotFrames.L.y(1:preludeDurationFrames, :), gapFramesL, ...
        dotFrames.L.y(1 + preludeDurationFrames:end, :));
    
    out.R.x = cat(1, dotFrames.R.x(1:preludeDurationFrames, :), gapFramesR, ...
        dotFrames.R.x(1 + preludeDurationFrames:end, :));
    out.R.y = cat(1, dotFrames.R.y(1:preludeDurationFrames, :), gapFramesR, ...
        dotFrames.R.y(1 + preludeDurationFrames:end, :));
end