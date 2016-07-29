function gui_loadProject(varargin)
%% will load ONE selected project

    close all;
    dirData = setPath;
    gui.data = dirData.data;
       
    if(~nargin)
        dirname = uigetdir(gui.data);
        ProjectName = dirname;        
    else
        ProjectName = varargin{1};
    end
    
    gui.projectData = loadProject(ProjectName);
    gui.projPath = ProjectName;

    %% Titles sessions + 'all'
    gui.sessionsList = getSessionsList(ProjectName);
    gui.sessionsStr{end + 1} = 'all';
    
    gui.sessionPos = 1;
    gui.currentSessionStr = gui.sessionsList{gui.sessionPos};
    
    %% Titles conditions 
    gui.conditions = getConditionsList(fullfile(gui.proj, gui.currentSessionStr));
    gui.conditionPos = 1;
    gui.currentSessionStr = gui.conditions{gui.conditionPos};
 
    
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
                 'string', ProjectName, 'visible', 'on');

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
    
     % plot left eye trajectories
     gui.left = axes('units','normalized', ...
            'position',[0.38 0.05 0.6 0.25], ...
            'xtick',[],'ytick',[], 'box', 'on');
%      uicontrol('style','text',...
%                  'unit','normalized',...
%                  'position',[0.62 0.3 0.09 0.05],...
%                  'backgroundc',get(gui.fh,'color'),...
%                  'fontsize', 16, 'fontweight','bold',... 
%                  'string', 'Left Eye' ,'visible', 'on');

     % plot right eye trajectories
     gui.right = axes('units','normalized', ...
            'position',[0.38 0.37 0.6 0.25], ...
            'xtick',[],'ytick',[], 'box', 'on');
%      uicontrol('style','text',...
%                  'unit','normalized',...
%                  'position',[0.62 0.62 0.09 0.05],...
%                  'backgroundc',get(gui.fh,'color'),...
%                  'fontsize', 16, 'fontweight','bold',... 
%                  'string', 'Right Eye', 'visible', 'on');
        
     %plot vergence/version             
     gui.ver = axes('units','normalized', ...
            'position',[0.38 0.7 0.6 0.25], ...
            'xtick',[],'ytick',[], 'box', 'on');
%      uicontrol('style','text',...
%                  'unit','normalized',...
%                  'position',[0.62 0.92 0.14 0.05],...
%                  'backgroundc',get(gui.fh,'color'),...
%                  'fontsize', 16, 'fontweight','bold',... 
%                  'string', 'Vergence/Version','visible', 'on');
        
    fontSettings = {'fontsize', 14, 'fontweight','bold'};
    set(get(gui.left, 'XLabel'), 'String', 'Time (milliseconds)', fontSettings{:});
    set(get(gui.left, 'YLabel'), 'String', 'Position Left Eye(deg)', fontSettings{:});
    
    set(get(gui.right, 'XLabel'), 'String', 'Time (milliseconds)', fontSettings{:});
    set(get(gui.right, 'YLabel'), 'String', 'Position Right Eye(deg)', fontSettings{:})    
    
    set(get(gui.ver, 'XLabel'), 'String', 'Time (milliseconds)', fontSettings{:});
    set(get(gui.ver, 'YLabel'), 'String', 'Vergence and version(deg)', fontSettings{:})    

    set(gui.popSsn, 'callback', {@popSsn_call, gui});  % Set the popup callback.
    set(gui.popCnd, 'callback', {@popCnd_call, gui});  % Set the popup callback.
    set(gui.pbPlot, 'callback', {@pb_call, gui});
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
    S.currCnd = S.conditions{get(S.popCnd, 'val')};
        
    data = loadConditionData(S);
    lX = squeeze(data.pos.L(:, 1, :));
    lY = squeeze(data.pos.L(:, 2, :));
            
    rX = squeeze(data.pos.R(:, 1, :));
    rY = squeeze(data.pos.R(:, 2, :));
    
    lvX = squeeze(data.vel.L(:, 1, :));
    lvY = squeeze(data.vel.L(:, 2, :));
            
    rvX = squeeze(data.vel.R(:, 1, :));
    rvY = squeeze(data.vel.R(:, 2, :));
    
    
    stimPos = calcStimsetTrajectory(data.info);
    %get plot type
    set(0,'CurrentFigure', S.fh);
    
    % Fill left eye data
    set(S.fh,'CurrentAxes', S.left); 
    cla(S.left); 
    plotOneEye(data.timecourse, -lX, -lY, 'Left eye', 'b', stimPos.l);
        
    %% plot right eye
    
    set(S.fh,'CurrentAxes',S.right);
    cla(S.right);
    plotOneEye(data.timecourse, -rX, -rY, 'Right eye', 'r', stimPos.r);    
    %% plot vergence/version 
     
    set(S.fh,'CurrentAxes',S.ver);
    cla(S.ver);
    p1 = plotOneEye(data.timecourse, lX - lY, rX - rY, 'vergence', 'k', {}); hold on;
    p2 = plotOneEye(data.timecourse, lvX - lvY, rvX - rvY, 'version', 'g', {}); hold on;
    legend([p1 p2], {'Vergence', 'Version'});
end

function updateCndList(S)
    if (~strcmp(S.currSsn, 'all'))
        S.conditions = getConditionsList(fullfile(S.proj, S.currSsn));
        S.currCnd = S.conditions{S.cndPos};
        cndData = loadConditionData(S);     
        displayCndInfo(S, cndData.info); 
    end
    %updateCallbacks(S);     
end

function dataOut = loadConditionData(S)
    S.ssnPos = get(S.popSsn, 'val');
    S.currSsn = S.sessions{S.ssnPos};
    S.cndPos = get(S.popCnd, 'val');
    S.currCnd = S.conditions{S.cndPos};
    
    if strcmp(S.currSsn, 'all')
    %load and average all data
        posL = [];
        posR = [];
        velL = [];
        velR = [];
        for s = 1:numel(S.sessions) - 1
            dataSession = loadSession(fullfile(S.proj, S.sessions{s}));
            dataC = dataSession{S.cndPos};
            posL = cat(3, posL, dataC.pos.L);
            posR = cat(3, posR, dataC.pos.R);
            velL = cat(3, velL, dataC.vel.L);
            velR = cat(3, velR, dataC.vel.R);
        end
        dataOut.pos.L = posL;
        dataOut.pos.R = posR;
        dataOut.vel.L = velL;
        dataOut.vel.R = velR;
        dataOut.info = dataSession{S.cndPos}.info;
        dataOut.timecourse = dataSession{S.cndPos}.timecourse;
    else
        dataSession = loadSession(fullfile(S.proj, S.currSsn));
        dataOut = dataSession{S.cndPos};
    end
end

function updateCallbacks(S)
    set(S.popSsn, 'callback', {@popSsn_call, S});
    set(S.popSsn, 'value',  S.ssnPos);
    
    set(S.popCnd, 'callback', {@popCnd_call, S});
    set(S.popCnd, 'string', S.conditions);
    set(S.pbPlot, 'callback', {@pb_call, S});
end


function displayCndInfo(S, data)
    list_fields = fields(data);
    % take out the nonius lines structure and display info
    
    excludedFields = ismember(list_fields, 'nonius') + ...
        ismember(list_fields, 'handle') + ...
        ismember(list_fields, 'name');
    
     list_fields = list_fields(~excludedFields) ;

    
    for f = 1:numel(list_fields)
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
