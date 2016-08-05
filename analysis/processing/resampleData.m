function [xNew, yNew] = resampleData(xData, yData, trialDuration)
% data is a cell aray of vectors of different lengths
% xData is a cell array storing xPoints, 
% yData is a cell array that stores yPoints
% Agorithm: take maximum duration of xData and resample yData
%      
   maxPoints = trialDuration;
   
   xNew = linspace(1, maxPoints, maxPoints);
   nY = size(yData, 1);
   %yNew = cellfun(@interp1, yData, xData, xNew);
   yNew = zeros(maxPoints, size(yData{1}, 2), nY);
   for y = 1:nY
       try
           trialData = yData{y};
           nVars = size(trialData, 2);
           for v = 1:nVars
               cleanedData = inpaint_nans(trialData(:, v), 3);
               yNew(:, v, y) = interp1(1:xData(y), cleanedData, xNew, 'spline');
           end
       catch
           % Nans catching, do nothing at this point
       end
   end
end