function gui_loadSession1D(varargin)
    close all;
    dirData = setPath;
    gui.data = dirData.data;
       
    if(~nargin)
        dirname = uigetdir(gui.data);
        sessionPath = dirname;        
    else
        sessionPath = varargin{1};
    end
    gui.session = loadSession1D(sessionPath);
    
    %% conditions
    gui.conditions = getConditionsList(sessionPath);
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
                 'string', sessionPath,'visible', 'on');
          
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
     %% Plot
             
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

    set(gui.popCnd, 'callback', {@popCnd_call, gui});  % Set the popup callback.
    set(gui.pbPlot, 'callback', {@pb_call, gui});
end

function [] = popCnd_call(varargin)
% Callback for Conditions popupmenu.
    % Get the structure.
    S = varargin{3};  
    % Get the users choice from the popup        
    S.cndPos = get(S.popCnd, 'val'); 
    S.currCnd = S.conditions{S.cndPos};
    cndData = loadConditionData(S);     
    displayCndInfo(S, cndData.info);
end

function [] = pb_call(varargin)
    S = varargin{3};
    S.currCnd = S.conditions{get(S.popCnd, 'val')};
        
    data = loadConditionData(S);
    l = data.pos.L;
    r = data.pos.R;
            
    lv = data.vel.L;
    rv = data.vel.R;
    
    %get plot type
    set(0,'CurrentFigure', S.fh);
    
    % Fill left eye data
    set(S.fh,'CurrentAxes', S.left); 
    cla(S.left); 
    plotOneEye1D(data.timecourse, -l, 'Left eye', 'b', {});
        
    %% plot right eye
    
    set(S.fh,'CurrentAxes',S.right);
    cla(S.right);
    plotOneEye1D(data.timecourse, -r, 'Right eye', 'r', {});
    
    
    %% plot vergence/version 
     
    set(S.fh,'CurrentAxes',S.ver);
    cla(S.ver);
    plotOneEye1D(data.timecourse, l-r, 'vergence', 'k', {}); hold on;
end

function updateCallbacks(S)
    set(S.popCnd, 'callback', {@popCnd_call, S});
    set(S.popCnd, 'string', S.conditions);
    set(S.pbPlot, 'callback', {@pb_call, S});
end

function dataOut = loadConditionData(S)
    dataSession = S.session;
    dataOut = dataSession{S.cndPos};
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

