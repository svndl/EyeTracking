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
           cleanedData = inpaint_nans(yData{y}, 3);
           yNew(:, :, y) = interp1(xData{y}, cleanedData, xNew, 'spline');
       catch
           % Nans catching, do nothing at this point
       end
   end
end