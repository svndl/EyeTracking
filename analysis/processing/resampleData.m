function [xNew, yNew, yOld] = resampleData(yData, trialSamples, upsampleRate, nanThresh)
% data is a cell aray of vectors of different lengths
% xData is a cell array storing xPoints, 
% yData is a cell array that stores yPoints
% Agorithm: take maximum duration of xData and resample yData
%      
    maxPoints = trialSamples;
    x0 = linspace(1, maxPoints, maxPoints);
    xNew = linspace(1, maxPoints*upsampleRate, maxPoints*upsampleRate);
    nTrials = size(yData, 1);
    %yNew = cellfun(@interp1, yData, xData, xNew);
    yNew = NaN*ones(maxPoints*upsampleRate, size(yData{1}, 2) - 1, nTrials);
    yOld = NaN*ones(maxPoints, size(yData{1}, 2) - 1, nTrials);
    y = 1;
    while y<= nTrials
        try
            trialData = yData{y};
            nVars = size(trialData, 2) - 1; % exclude quality column;
            nanPercent = sum(isnan(trialData))./size(trialData, 1);
            if (any(nanPercent > nanThresh))
                fprintf('Trial %d will be rejected, %d percent NaN\n', y, 100*max(nanPercent));
            else
                for v = 1:nVars
                    cleanedData = trialData(:, v);
                    if (nanPercent(v))
                        cleanedData = inpaint_nans(trialData(:, v), 3);
                    end
                    y_oldRate = interp1(cleanedData, x0);
                    yNew(:, v, y) = interp(y_oldRate, upsampleRate);
                    yOld(:, v, y) = y_oldRate;
                end
            end
        catch err
            display(['Function resampleData error processing trial # = ' num2str(y)]);
            display(err.message);
            for e = 1: numel(err.stack)
                display(err.stack(e).file);
                display(err.stack(e).line);
            end   
        end
        y = y + 1;
    end
end