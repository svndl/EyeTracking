function plotBothEyes1D(data, type, varargin)
     stimPosl = {};
     stimPosr = {};
     
    if (~isempty(varargin))
        stimPosl = varargin{1}.l;
        stimPosr = varargin{1}.r;        
    end
    
    
    timecourse = 1:size(data.L, 1);
    
    subplot(2, 1, 1)        
        
    plotOneEye1D(timecourse, data.L, [type ' left'], 'b', ...
            stimPosl); 
    
        subplot(2, 1, 2)
    plotOneEye1D(timecourse, data.R, [type ' right'], 'r', ... 
            stimPosr);
end
