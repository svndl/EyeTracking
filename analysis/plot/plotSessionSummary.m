function plotSessionSummary(varargin)
% function will plot session's summary: 
    
    % select session
    
    dirData = setPath;
    if(~nargin)
        dirname = uigetdir(dirData.data);
        sessionPath = dirname;        
    else
        sessionPath = varargin{1};
    end
    
    % figures will be saved in SESSION_DIR/figures
    
    figurePath = fullfile(sessionPath, 'figures');
    if (~exist(figurePath, 'dir'))
        mkdir(figurePath);
    end
    
    sessionData = loadSession(sessionPath);    
    nCnd = numel(sessionData);
    close all;
    for c = 1:nCnd
        data = sessionData{c};
        stimPos = calcStimsetTrajectory(data.info);
        nSamples = numel(data.timecourse);
        s.l.x = takeLastN(stimPos.l.x, nSamples);
        s.l.y = takeLastN(stimPos.l.y, nSamples);
        s.r.x = takeLastN(stimPos.r.x, nSamples);
        s.r.y = takeLastN(stimPos.r.y, nSamples);
    
        sv.x =  s.l.x - s.r.x;
        sv.y =  s.l.y - s.r.y;
    
        %% Plot L/R trajectories
        
        %open new figure
        posLR = figure;
        title('Left and Right eye trajectories');
        
        % plot L/R trajectories and stimset
        data.pos.L = -data.pos.L;
        data.pos.R = -data.pos.R;
        
        [lX, lY, rX, rY] = plotBothEyes(data.pos, 'pos', s);
        
        % save figure
        saveas(posLR, fullfile(figurePath, ['Eyes Trajectories_cnd' num2str(c)]), 'fig');
        %close figure
        close gcf;
        
        %% Plot L/R Velocities
        velLR = figure;
        title('Left and Right eye velocity');
        
        
        plotBothEyes(data.vel, 'vel');
        saveas(velLR, fullfile(figurePath, ['Eyes Velo_cnd' num2str(c)]), 'fig');
        close gcf;
        
        %% Plot L/R Vergence and Version
        ver_ver = figure;
        title('Vergence and Version');
        
        subplot(2, 1, 1)
        plotOneEye(data.timecourse, -(lX - rX), -(lY - rY), 'vergence', 'k', sv);
        
        subplot(2, 1, 2)
        plotOneEye(data.timecourse, -cat(2, lX, rX), -cat(2, lY, rY), 'version', 'g', {});
        
        saveas(ver_ver, fullfile(figurePath, ['Eyes Vergence_cnd' num2str(c)]), 'fig');
        close gcf;     

        
        %% Get yer response pie charts here
        
        % user response is in data.response 
        % direction of motion is in data.info.direction
       
    end
end