function [xNew, yNew, yOld] = resampleData(yData, trialSamples, upsampleRate)
% data is a cell aray of vectors of different lengths
% xData is a cell array storing xPoints, 
% yData is a cell array that stores yPoints
% Agorithm: take maximum duration of xData and resample yData
%      
    maxPoints = trialSamples;
    nanThresh = 0.15;
    x0 = linspace(1, maxPoints, maxPoints);
    xNew = linspace(1, maxPoints*upsampleRate, maxPoints*upsampleRate);
    nTrials = size(yData, 1);
    %yNew = cellfun(@interp1, yData, xData, xNew);
    yNew = zeros(maxPoints*upsampleRate, size(yData{1}, 2), nTrials);
    yOld = zeros(maxPoints, size(yData{1}, 2), nTrials);
    for y = 1:nTrials
        try
            trialData = yData{y};
            nVars = size(trialData, 2) - 1; % exclude quality column;
            for v = 1:nVars
                pnan = sum(isnan(trialData(:, v)))/numel(trialData(:, v));
                if (pnan < nanThresh)
                    cleanedData = inpaint_nans(trialData(:, v), 3);
                    y_oldRate = interp1(cleanedData, x0);
                    yNew(:, v, y) = interp(y_oldRate, upsampleRate);
                    yOld(:, v, y) = y_oldRate;
                else
                    fprintf('Trial %d rejected, %d percent NaN\n', y, 100*pnan);
                    yNew(:, :, y) = [];
                    %goto next trial
                    v = 1;
                    y = y+1;
                end
            end
        catch
            % Nans catching, do nothing at this point
        end
    end
end