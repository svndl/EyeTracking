function gui_loadProject
    close all;
    
    dirData = setPath;
    gui.data = dirData.data;
    %% projects
    gui.projPos = 1;
    gui.projects = getProjectsList(gui.data); 
    gui.currProj =  gui.projects{gui.projPos};
    
    %% sessions
    gui.sessions = getSessionsList(fullfile(gui.data, gui.currProj));
    % add 'ALL'
    gui.sessions{end + 1} = 'all';
    gui.ssnPos = 1;
    gui.currSsn = gui.sessions{gui.ssnPos};
    
    %% conditions
    gui.conditions = getConditionsList(fullfile(gui.data, gui.currProj, gui.currSsn));
    gui.cndPos = 1;
    gui.currCnd = gui.conditions{gui.cndPos};
 
    
    gui.fh = figure('units','normalized',...
              'position',[0 0 0.5 0.5],...
              'menubar','none',...
              'name','SceneEditor',...
              'numbertitle','off',...
              'resize','on');
   
    uicontrol('style','text',...
                 'unit','normalized',...
                 'position',[0.05 0.8 0.2 0.2],...
                 'backgroundc',get(gui.fh,'color'),...
                 'fontsize', 16, 'fontweight','bold',... 
                 'string', 'List of Projects','visible', 'on');

    gui.popProj = uicontrol('style','pop',...
                 'unit','normalized',...
                 'position',[0.05 0.75 0.2 0.2],...
                 'backgroundc',get(gui.fh,'color'),...
                 'fontsize',12,'fontweight','bold',... 
                 'string', gui.projects, 'value', gui.projPos);
    %% Subjects
    uicontrol('style','text',...
                 'unit','normalized',...
                 'position',[0.05 0.7 0.2 0.2],...
                 'backgroundc',get(gui.fh,'color'),...
                 'fontsize', 16, 'fontweight','bold',... 
                 'string', 'List of sessions','visible', 'on');

    gui.popSsn  = uicontrol('style','pop',...
                 'unit','normalized',...
                 'position',[0.05 0.65 0.2 0.2],...
                 'backgroundc',get(gui.fh,'color'),...
                 'fontsize',12,'fontweight','bold',... 
                 'string', gui.sessions,'value', gui.ssnPos);
    %% Conditions
    uicontrol('style','text',...
                 'unit','normalized',...
                 'position',[0.05 0.6 0.2 0.2],...
                 'backgroundc',get(gui.fh,'color'),...
                 'fontsize', 16, 'fontweight','bold',... 
                 'string', 'Conditions','visible', 'on');

    gui.popCnd = uicontrol('style','pop',...
                 'unit','normalized',...
                 'position',[0.05 0.55 0.2 0.2],...
                 'backgroundc',get(gui.fh,'color'),...
                 'fontsize',12,'fontweight','bold',... 
                 'string',gui.conditions,'value', gui.cndPos);
            
    gui.pbPlot = uicontrol('style','push',...
                 'units','normalized',...
                 'position',[0.05 0.6 0.2 0.05],...
                 'backgroundcolor','w',...
                 'HorizontalAlign','center',...
                 'string','Plot condition',...
                 'fontsize',14,'fontweight','bold');             
    
    %% Condition info            
     cndData = loadConditionData(gui);     
     displayCndInfo(gui, cndData.info);
                          
    
     gui.left = axes('units','normalized', ...
            'position',[0.38 0.05 0.6 0.43], ...
            'xtick',[],'ytick',[], 'box', 'on');
%             'XColor',[0 0 .7], ...
%             'YColor',[0 0 .7], ...            
       
     gui.right = axes('units','normalized', ...
            'position',[0.38 0.5 0.6 0.43], ...
            'xtick',[],'ytick',[], 'box', 'on');
%             'XColor',[.7 0 0], ...
%             'YColor',[.7 0 0], ...                        

    set(get(gui.left, 'XLabel'), 'String', 'Time (milliseconds)');
    set(get(gui.left, 'YLabel'), 'String', 'Position Eyes(deg)');
    
    set(get(gui.right, 'XLabel'), 'String', 'Time (milliseconds)')
    set(get(gui.right, 'YLabel'), 'String', 'Velocity Eyes(deg)')    
    
    set(gui.popProj, 'callback', {@popProj_call, gui});  % Set the popup callback.
    set(gui.popSsn, 'callback', {@popSsn_call, gui});  % Set the popup callback.
    set(gui.popCnd, 'callback', {@popCnd_call, gui});  % Set the popup callback.
    set(gui.pbPlot, 'callback', {@pb_call, gui});
end

function [] = popProj_call(varargin)
% Callback for Projects popupmenu.
    S = varargin{3}; 
    S.projPos = get(S.popProj, 'val');
    S.currProj = S.projects{S.projPos};
    updateSsnList(S);
end    
function [] = popSsn_call(varargin)
% Callback for Sessions popupmenu.
    S = varargin{3}; 
    S.ssnPos = get(S.popSsn, 'val'); 
    S.currSsn = S.sessions{S.ssnPos};
    if (~strcmp(S.currSsn, 'all'))
        updateCndList(S);
    end
end

function [] = popCnd_call(varargin)
% Callback for Conditions popupmenu.
    S = varargin{3};  % Get the structure.
    S.cndPos = get(S.popCnd, 'val'); % Get the users choice from the popup     
    S.currCnd = S.conditions{S.cndPos};
    cndData = loadConditionData(S);     
    displayCndInfo(S, cndData.info);
end

%%
function [] = pb_call(varargin)
    S = varargin{3};
    S.currProj = S.projects{get(S.popProj, 'val')};
    S.currSsn = S.sessions{get(S.popSsn, 'val')};
    S.currCnd = S.conditions{get(S.popCnd, 'val')};
        
    data = loadConditionData(S);
    %get plot type
    set(0,'CurrentFigure', S.fh);
    
    set(S.fh,'CurrentAxes', S.left); 
    cla(S.left); 
    plot(data.pos.L, '-b'); hold on;
    plot(data.pos.R, '-r'); hold on;
    plot(data.pos.Vergence, '-.k'); hold on;
    plot(data.pos.Version, '.k'); hold on;
    
    legend({'position L', 'position R', 'vergence', 'version'});
    
    set(S.fh,'CurrentAxes',S.right);
    cla(S.right);
    plot(data.vel.L, '-b'); hold on;
    plot(data.vel.R, '-r'); hold on;
    plot(data.vel.Vergence, '-.k'); hold on;
    plot(data.vel.Version, '.k'); hold on;
    legend({'velocity L', 'velocity R', 'vergence velocity', 'version velocity'});
end
function updateSsnList(S)
    newSsnList = getSessionsList(fullfile(S.data, S.currProj));
    % add 'all' session
    S.sessions = [newSsnList {'all'}];
    S.currSsn = S.sessions{S.ssnPos};    
    updateCndList(S);
end
function updateCndList(S)
    if (~strcmp(S.currSsn, 'all'))
        S.conditions = getConditionsList(fullfile(S.data, S.currProj, S.currSsn));
        S.currCnd = S.conditions{S.cndPos};
        cndData = loadConditionData(S);     
        displayCndInfo(S, cndData.info); 
    end
    %updateCallbacks(S);     
end

function updateCallbacks(S)
    set(S.popProj, 'callback', {@popProj_call, S}); 
    set(S.popSsn, 'callback', {@popSsn_call, S});
    set(S.popSsn, 'string', S.sessions);
    set(S.popSsn, 'value',  S.ssnPos);
    set(S.popCnd, 'callback', {@popCnd_call, S});
    set(S.popCnd, 'string', S.conditions);
    set(S.pbPlot, 'callback', {@pb_call, S});
end

function data = loadConditionData(S)
    S.currProj = S.projects{get(S.popProj, 'val')};
    S.ssnPos = get(S.popSsn, 'val');
    S.currSsn = S.sessions{S.ssnPos};
    S.cndPos = get(S.popCnd, 'val');
    S.currCnd = S.conditions{S.cndPos};
    if strcmp(S.currSsn, 'all')
    %load and average all data        
        for s = 1:numel(S.sessions) - 1
            dataSession = loadSession(fullfile(S.data, S.currProj, S.sessions{s}));
            dataC = dataSession{S.cndPos};
            posL(s, :, :) = dataC.pos.L;
            posR(s, :, :) = dataC.pos.R;
            velL(s, :, :) = dataC.vel.L;
            velR(s, :, :) = dataC.vel.R;
            posVergence(s, :, :) = dataC.pos.Vergence;
            posVersion(s, :, :) = dataC.pos.Version;
            velVergence(s, :, :) = dataC.vel.Vergence;
            velVersion(s, :, :) = dataC.vel.Version;
        end
        data.pos.L = squeeze(mean(posL, 1));
        data.pos.R = squeeze(mean(posR, 1));
        data.pos.Vergence = squeeze(mean(posVergence, 1));
        data.pos.Version = squeeze(mean(posVersion, 1));
        data.vel.L = squeeze(mean(velL, 1));
        data.vel.R = squeeze(mean(velR, 1));
        data.vel.Vergence = squeeze(mean(velVergence, 1));
        data.vel.Version = squeeze(mean(velVersion, 1)); 
    else
        dataSession = loadSession(fullfile(S.data, S.currProj, S.currSsn));
        data = dataSession{S.cndPos};
        plotTiming = 0;
        checkSessionTiming(dataSession, plotTiming);
    end
end

function displayCndInfo(S, data)
    list_fields = fields(data);
    
    % don't process the last 'display' field
    for f = 1:numel(list_fields) - 1
        % text
       uicontrol('style','text',...
                 'unit','normalized',...
                 'position',[0.05 0.45 - 0.03*f 0.2 0.15],...
                 'backgroundc',get(S.fh,'color'),...
                 'fontsize', 12, 'HorizontalAlignment','left', ...
                 'string', list_fields{f}, 'visible', 'on');
        
        %data
        val = data.(list_fields{f});
        if(isnumeric(val))
            dataStr = num2str(val);
        else
            dataStr = val;
        end
        uicontrol('style','text',...
                 'unit','normalized',...
                 'position',[0.17 0.45 - 0.03*f 0.2 0.15],...
                 'backgroundc',get(S.fh,'color'),...
                 'fontsize', 12, 'HorizontalAlignment','left', ...
                 'string', dataStr, 'visible', 'on');
             
    end
    updateCallbacks(S);
end

