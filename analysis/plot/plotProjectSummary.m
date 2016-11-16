function plotProjectSummary(varargin)
% function will plot session's summary: 
    
    % select session
    
    dirData = setPath;
    if(~nargin)
        dirname = uigetdir(dirData.data);
        projectPath = dirname;        
    else
        projectPath = varargin{1};
    end
    
    % figures will be saved in SESSION_DIR/figures
    
    figurePath = fullfile(projectPath, 'figuresProject');
    if (~exist(figurePath, 'dir'))
        mkdir(figurePath);
    end
    
    projectData = loadProject(projectPath);
    
    nCnd = numel(projectData{1});
    close all;
    
    for c = 1:nCnd
        %% merge project data
        posL = [];
        posR = [];
        velL = [];
        velR = [];
        for s = 1:numel(projectData)
            sessoinData = projectData{s};
            conditionData = sessoinData{c};
            posL = cat(3, posL, conditionData.pos.L);
            posR = cat(3, posR, conditionData.pos.R);
            velL = cat(3, velL, conditionData.vel.L);
            velR = cat(3, velR, conditionData.vel.R);
        end
        stimPos = calcStimsetTrajectory(conditionData.info); 
        nSamples = numel(conditionData.timecourse);
        sp.l.x = takeLastN(stimPos.l.x, nSamples);
        sp.l.y = takeLastN(stimPos.l.y, nSamples);
        sp.r.x = takeLastN(stimPos.r.x, nSamples);
        sp.r.y = takeLastN(stimPos.r.y, nSamples);
    
        sv.x =  sp.l.x - sp.r.x;
        sv.y =  sp.l.y - sp.r.y;
        pos.L = posL;
        pos.R = posR;
        vel.L = velL;
        vel.R = velR;
        
        
        %% Plot L/R trajectories
        %open new figure
        posLR = figure;
        title('Left and Right eye trajectories');
        
        % plot L/R trajectories and stimset
        [lX, lY, rX, rY] = plotBothEyes(pos, 'pos', sp);
        
        % save figure
        saveas(posLR, fullfile(figurePath, ['Eyes Trajectories_cnd' num2str(c)]), 'fig');
        %close figure
        close gcf;
        
        %% Plot L/R Velocities
        velLR = figure;
        title('Left and Right eye velocity');
        
        
        plotBothEyes(vel, 'vel');
        saveas(velLR, fullfile(figurePath, ['Eyes Velo_cnd' num2str(c)]), 'fig');
        close gcf;
        
        %% Plot L/R Vergence and Version
        ver_ver = figure;
        title('Vergence and Version');
        timecourse = 1:size(lX, 1);
        subplot(2, 1, 1)
        plotOneEye(timecourse, -(lX - rX), -(lY - rY), 'vergence', 'k', sv);
        
        subplot(2, 1, 2)
        plotOneEye(timecourse, -cat(2, lX, rX), -cat(2, lY, rY), 'version', 'g', {});
        
        saveas(ver_ver, fullfile(figurePath, ['Eyes Vergence_cnd' num2str(c)]), 'fig');
        close gcf;     

        
        %% Get yer response pie charts here
        
        % user response is in data.response 
        % direction of motion is in data.info.direction
       
    end
end