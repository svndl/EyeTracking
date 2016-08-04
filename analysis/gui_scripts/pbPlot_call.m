function [] = pbPlot_call(varargin)
    S = varargin{3};
        
    data = loadConditionData(S);
    lX = -squeeze(data.pos.L(:, 1, :));
    lY = -squeeze(data.pos.L(:, 2, :));
            
    rX = -squeeze(data.pos.R(:, 1, :));
    rY = -squeeze(data.pos.R(:, 2, :));
    
    lvX = -squeeze(data.vel.L(:, 1, :));
    lvY = -squeeze(data.vel.L(:, 2, :));
            
    rvX = -squeeze(data.vel.R(:, 1, :));
    rvY = -squeeze(data.vel.R(:, 2, :));
    
    
    stimPos = calcStimsetTrajectory(data.info);
    nSamples = numel(data.timecourse);
    sl.x = takeLastN(stimPos.l.x, nSamples);
    sl.y = takeLastN(stimPos.l.y, nSamples);
    sr.x = takeLastN(stimPos.r.x, nSamples);
    sr.y = takeLastN(stimPos.r.y, nSamples);
    
    sv.x =  sl.x - sr.x;
    sv.y =  sl.y - sr.y;
    
    set(0,'CurrentFigure', S.fh);
    
    %% position
    % plot left eye pos
    set(S.fh,'CurrentAxes', S.pos_left); 
    cla(S.pos_left); 
    plotOneEye(data.timecourse, lX, lY, 'Left eye', 'b', sl);
        
    % plot right eye pos
    set(S.fh,'CurrentAxes',S.pos_right);
    cla(S.pos_right);
    plotOneEye(data.timecourse, rX, rY, 'Right eye', 'r', sr);    
    
    % plot vergence 
    set(S.fh,'CurrentAxes',S.pos_verg);
    cla(S.pos_verg);
    plotOneEye(data.timecourse, lX - rX, lY - rY, 'vergence', 'k', sv);
    
    % plot version 
    set(S.fh,'CurrentAxes',S.pos_vers);
    cla(S.pos_vers);
    plotOneEye(data.timecourse, cat(2, lX, rX), cat(2, lY, rY), 'version', 'g', sv);
    
    %% velocity 
    % plot left eye velo
    set(S.fh,'CurrentAxes', S.vel_left); 
    cla(S.vel_left); 
    plotOneEye(data.timecourse, lvX, lvY, 'Left eye velo', 'b', {});
        
    % plot right eye velo
    set(S.fh,'CurrentAxes',S.vel_right);
    cla(S.vel_right);
    plotOneEye(data.timecourse, rvX, rvY, 'Right eye velo', 'r', {});    
       
    % plot vergence 
    set(S.fh,'CurrentAxes',S.vel_verg);
    cla(S.vel_verg);
    plotOneEye(data.timecourse, lvX - rvX, lvY - rvY, 'vergence', 'k', {});
    
    % plot version 
    set(S.fh,'CurrentAxes',S.vel_vers);
    cla(S.vel_vers);
    plotOneEye(data.timecourse, cat(2, lvX, rvX), cat(2, lvY, rvY), 'version', 'g', {});
    
    % update axes
    
    fontSettings = {'fontsize', 14, 'fontweight','bold'};
    set(get(S.pos_left, 'XLabel'), 'String', 'Time (milliseconds)', fontSettings{:});
    set(get(S.pos_left, 'YLabel'), 'String', 'Position Left Eye(deg)', fontSettings{:});
    
    set(get(S.pos_right, 'XLabel'), 'String', 'Time (milliseconds)', fontSettings{:});
    set(get(S.pos_right, 'YLabel'), 'String', 'Position Right Eye(deg)', fontSettings{:})    
    
    set(get(S.pos_verg, 'XLabel'), 'String', 'Time (milliseconds)', fontSettings{:});
    set(get(S.pos_verg, 'YLabel'), 'String', 'Vergence(deg)', fontSettings{:})    

    set(get(S.pos_vers, 'XLabel'), 'String', 'Time (milliseconds)', fontSettings{:});
    set(get(S.pos_vers, 'YLabel'), 'String', 'Version(deg)', fontSettings{:})    
    
    set(get(S.vel_left, 'XLabel'), 'String', 'Time (milliseconds)', fontSettings{:});
    set(get(S.vel_left, 'YLabel'), 'String', 'Velocity Left Eye(deg/s)', fontSettings{:});
    
    set(get(S.vel_right, 'XLabel'), 'String', 'Time (milliseconds)', fontSettings{:});
    set(get(S.vel_right, 'YLabel'), 'String', 'Velocity Right Eye(deg/s)', fontSettings{:})    
    
    set(get(S.vel_verg, 'XLabel'), 'String', 'Time (milliseconds)', fontSettings{:});
    set(get(S.vel_verg, 'YLabel'), 'String', 'Velocity Left Eye(deg/s)', fontSettings{:});
    
    set(get(S.vel_vers, 'XLabel'), 'String', 'Time (milliseconds)', fontSettings{:});
    set(get(S.vel_vers, 'YLabel'), 'String', 'Velocity Right Eye(deg/s)', fontSettings{:})     
end