%%
function [lbarFrame, rbarFrame] = BarFrame(barParams, videoMode)
% number of frames for prelude
framesPerUpdate = round(videoMode.frameRate/barParams.dotUpdateHz);
nPreludeFrames = round(barParams.prelude.durationSec*videoMode.frameRate/framesPerUpdate);

% calculate stimset params, get rid of struct data type
barParams = bar_calcStimsetParams(barParams, videoMode);

barParams = struct2cell(barParams);


[lFrames, rFrames] = makeBarFrame(barParams{:});

preludeFrames = repmat(squeeze(lFrames(:, :, 1)),[1 1 nPreludeFrames]);

lbarFrame = cat(3, preludeFrames, lFrames);
rbarFrame = cat(3, preludeFrames, rFrames);

end


function [lbarFrame, rbarFrame] = makeBarFrame(width, height, minWidth, cor, displacementPix, direction, dur, nframe)
%makeBarFrame()

%nframe = dur*scr.frameRate;

%Lbar and Rbar matrix 1st frame

lbarFrame(:,:,1) = makeMatrix(width, height, minWidth);


switch cor
    case 0
        rbarFrame(:,:,1) = makeMatrix(width, height, minWidth);
        
    case 1
        rbarFrame(:,:,1) = lbarFrame(:,:,1);
        
    case -1
        rbarFrame(:,:,1) = 1-lbarFrame(:,:,1);
        
end


%Shift bar, make barframe.
for n = 1:(nframe-1)
    [lbarFrame(:,:,n+1), rbarFrame(:,:, n+1)] = shiftBar(lbarFrame(:,:,n),rbarFrame(:,:,n), displacementPix,direction);
        
end

end

function barMatrix = makeMatrix(width,height,minWidth)


vec = rand(1, fix(width/minWidth));
vec(vec >= .5) =1;
vec(vec < .5) =0;
row = my_repelem(vec,1,minWidth);
if mod(width,minWidth) ~= 0
    row = [row my_repelem(row(end),1, mod(width,minWidth))];
    
end
barMatrix = repmat(row, [height 1]);

end


function [lBarshifted, rBarshifted] = shiftBar(lbar,rbar, displacementPix,direction)

rshift = @(x) [x(:,end-displacementPix+1:end) x(:,1:end-displacementPix)];
lshift = @(x) [x(:,displacementPix+1:end) x(:,1:displacementPix)];

%Right Eye
if directionSigns(direction,'R') == 1
    rBarshifted = rshift(rbar);
else
    rBarshifted = lshift(rbar);
end

if directionSigns(direction,'L') == 1
    lBarshifted = rshift(lbar);
else
    lBarshifted = lshift(lbar);
end

end






