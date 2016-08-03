function gui_loadProject1D(varargin)
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
    
    gui.projectData = loadProject1D(ProjectName);
    gui.projPath = ProjectName;

    %% Titles sessions + 'all'
    gui.sessionsList = getSessionsList(ProjectName);
    gui.sessionsList{end + 1} = 'all';    
    gui.sessionPos = 1;
    
    %% Titles conditions 
    gui.conditionsList = getConditionsList(fullfile(gui.projPath, gui.sessionsList{gui.sessionPos}));
    gui.conditionPos = 1;
 
    
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
                 'string', gui.sessionsList,'value', gui.sessionPos);
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
                 'string',gui.conditionsList,'value', gui.conditionPos);
            
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
    
    % update condition info
    dataOut = loadConditionData(gui);
    displayCndInfo(gui, dataOut.info);
end
function [] = popSsn_call(varargin)
% Callback for Sessions popupmenu.
    S = varargin{3}; 
    dataOut = loadConditionData(S);
    displayCndInfo(S, dataOut.info);
    cla(S.left); 
    cla(S.right); 
    cla(S.ver); 
end

function [] = popCnd_call(varargin)
% Callback for Conditions popupmenu.
    S = varargin{3};
    cndData = loadConditionData(S);     
    displayCndInfo(S, cndData.info);
    cla(S.left); 
    cla(S.right); 
    cla(S.ver);    
end

%%
function [] = pb_call(varargin)
    S = varargin{3};
        
    data = loadConditionData(S);    
    
    %stimPos = calcStimsetTrajectory(data.info);
    %get plot type
    set(0,'CurrentFigure', S.fh);
    
    % Fill left eye data
    set(S.fh,'CurrentAxes', S.left); 
    cla(S.left); 
    plotOneEye1D(data.timecourse, data.L, 'Left eye', 'b', {});
        
    %% plot right eye
    
    set(S.fh,'CurrentAxes',S.right);
    cla(S.right);
    plotOneEye1D(data.timecourse, data.R, 'Right eye', 'r', {});    
    %% plot vergence/version 
     
    set(S.fh,'CurrentAxes',S.ver);
    cla(S.ver);
    plotOneEye1D(data.timecourse, data.L - data.R, 'vergence', 'k', {}); hold on;
end
function dataOut = loadConditionData(S)
    S.sessionPos = get(S.popSsn, 'val');
    S.conditionPos = get(S.popCnd, 'val');
    
    if strcmp(S.sessionsList{S.sessionPos}, 'all')
    %load and average all data
        posL = [];
        posR = [];
        velL = [];
        velR = [];
        for s = 1:numel(S.projectData)
            dataSession = S.projectData{s};
            dataC = dataSession{S.conditionPos};
            posL = cat(3, posL, dataC.pos.L);
            posR = cat(3, posR, dataC.pos.R);
            velL = cat(3, velL, dataC.vel.L);
            velR = cat(3, velR, dataC.vel.R);
        end
        dataOut.pos.L = posL;
        dataOut.pos.R = posR;
        dataOut.vel.L = velL;
        dataOut.vel.R = velR;
        dataOut.info = dataSession{S.conditionPos}.info;
        dataOut.timecourse = dataSession{S.conditionPos}.timecourse;
    else
        dataOut = S.projectData{S.sessionPos}{S.conditionPos};
    end
end

function updateCallbacks(S)
%     set(S.popSsn, 'callback', {@popSsn_call, S});
%     set(S.popSsn, 'value',  S.sessionPos); 
%     set(S.popCnd, 'callback', {@popCnd_call, S});
%     set(S.popCnd, 'string', S.conditions);
%     set(S.pbPlot, 'callback', {@pb_call, S});
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
