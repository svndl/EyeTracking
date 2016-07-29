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
    
        %% Plot L/R trajectories
        
        %open new figure
        posLR = figure;
        title('Left and Right eye trajectories');
        
        % plot L/R trajectories and stimset
        plotBothEyes(data.pos, 'pos', stimPos);
        
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
        plotOneEye(data.timecourse, lX - lY, rX - rY, 'vergence', 'k', {});
        
        subplot(2, 1, 2)
        plotOneEye(data.timecourse, lvX - lvY, rvX - rvY, 'version', 'g', {});
        
        saveas(ver_ver, fullfile(figurePath, ['Eyes Vergence_cnd' num2str(c)]), 'fig');
        close gcf;     

        
        %% Get yer response pie charts here
        
        % user response is in data.response 
        % direction of motion is in data.info.direction
       
    end
end