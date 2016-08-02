function [lX, lY, rX, rY] = plotBothEyes(data, type, varargin)
     stimPosl = {};
     stimPosr = {};
     
    if (~isempty(varargin))
        stimPosl = varargin{1}.l;
        stimPosr = varargin{1}.r;        
    end
    
    lX = squeeze(data.L(:, 1, :));
    lY = squeeze(data.L(:, 2, :));
            
    rX = squeeze(data.R(:, 1, :));
    rY = squeeze(data.R(:, 2, :));
    
    timecourse = 1:size(lX, 1);
    subplot(2, 1, 1)        
        
    plotOneEye(timecourse, lX, lY, [type ' left'], 'b', ...
            stimPosl); 
    
        subplot(2, 1, 2)
    plotOneEye(timecourse, rX, rY, [type ' right'], 'r', ... 
            stimPosr);
end
