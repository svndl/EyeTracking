function filtered = filterData(dataIn, fparams)%
%  dataIn matrix (time x coord (hor, vert) x nTrials ); 

% 
% - fpara: struct with settings for filter.
%  
%         fpara.which_filter: 'moving', 'lowess', 'loess', 'rlowess',
%                             'rloess', 'butter'
%
%         fpara.span        : span of the filters (samples)
%         fpara.order       : order of butterworth filter
%         fpara.curoff      : cutoff frequency of butterworth filter
%         fpara.ftype       : 'low','hight','bandpass','stop'
%
%         (Default values for filters need to be checked!)
%  
%         fpara.show_fit    : show orig. and smoothed data for each     
%                             data set, press key to continue
%  
%OUT
%
%- Adds the interpolated data to the Data structure
%  .filt_pos
%  .filt_vel
%  
   
  if (nargin<2 || isempty(fparams))
    fparams.which_filter = 'butter';
    fparams.span = 25;
    fparams.order = 2; 
    fparams.cutoff = 0.1;
    fparams.ftype = 'low';
    fparams.show_fit = 0;
  end
  
  filtered = applyFilter(dataIn, fparams);
end

function out = applyFilter(in, fpara)
%
%
   
  switch fpara.which_filter
    
   case {'moving', 'lowess', 'loess', 'rlowess', 'rloess'}
    
    if ~mod(fpara.span, 2)
      warning('Span has to be odd, data was NOT filtered\n')
      out = in;
      return;
    end
    filtered = smooth(in, fpara.span, fpara.which_filter);
   case 'butter'
    [b1, b2] = butter(fpara.order, fpara.cutoff, fpara.ftype);
    filtered = filter(b1, b2, in);
   case 'test'
    filtered = in;
  end
  
  if fpara.show_fit
    figure(1),
    hold on
    plot(mean(in, 3),  'k');
    plot(mean(filtered, 3), 'r');
    %plot(in(:,1),in(:,2)-out,'g')
    pause
    cla
  end
  out = filtered;
end


