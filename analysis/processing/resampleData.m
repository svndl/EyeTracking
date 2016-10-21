function [xNew, yNew] = resampleData(yData, trialSamples, upsampleRate)
% data is a cell aray of vectors of different lengths
% xData is a cell array storing xPoints, 
% yData is a cell array that stores yPoints
% Agorithm: take maximum duration of xData and resample yData
%      
    maxPoints = trialSamples;
    nanThresh = 0.15;
    x0 = linspace(1, maxPoints, maxPoints);
    xNew = linspace(1, maxPoints*upsampleRate, maxPoints*upsampleRate);
    nY = size(yData, 1);
    %yNew = cellfun(@interp1, yData, xData, xNew);
    yNew = zeros(maxPoints*upsampleRate, size(yData{1}, 2), nY);
    for y = 1:nY
        try
            trialData = yData{y};
            nVars = size(trialData, 2) - 1; % exclude quality column;
            for v = 1:nVars
                pnan = sum(isnan(trialData(:, v)))/numel(trialData(:, v));
                if (pnan < nanThresh)
                    cleanedData = inpaint_nans(trialData(:, v), 3);
                    y_oldRate = interp1(cleanedData, x0);
                    yNew(:, v, y) = interp(y_oldRate, upsampleRate);
                else
                    fprintf('Trial %d rejected, %d percent NaN\n', y, 100*pnan);
                    yNew(:, v, y) = [];
                end
            end
        catch
            % Nans catching, do nothing at this point
        end
    end
end