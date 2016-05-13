function gui_loadProject
    close all;
    
    dirData = setPath;
    gui.data = dirData.data;
    gui.default_pos = 1;
    gui.projects = getProjectsList(gui.data); 
    gui.currProj =  gui.projects{gui.default_pos};
    
    gui.sessions = getSessionsList(fullfile(gui.data, gui.currProj));
    % add 'ALL'
    gui.sessions{end + 1} = 'All';
    gui.currSsn = gui.sessions{gui.default_pos};
    
    gui.conditions = getConditionsList(fullfile(gui.data, gui.currProj, gui.currSsn));
    gui.currCnd = gui.conditions{gui.default_pos};
 
    
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
                 'string', gui.projects, 'value', gui.default_pos);
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
                 'string', gui.sessions,'value', gui.default_pos);
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
                 'string',gui.conditions,'value', gui.default_pos);
             
    
    %% Condition info            
     cndData = loadConditionData(gui);
     
     displayCndInfo(gui, cndData.info);
             
    %% Describing conditions info (all text)         
             
%     gui.pb = uicontrol('style','push',...
%                  'units','pix',...
%                  'position',[550 110 60 30],...
%                  'backgroundcolor','w',...
%                  'HorizontalAlign','left',...
%                  'string','Save X',...
%                  'fontsize',14,'fontweight','bold');             
%     
%      gui.left = axes('units','normalized',...
%             'position',[50 200 800 800], 'xtick',[],'ytick',[], 'box', 'on');
%         
%      gui.right = axes('units','normalized',...
%             'position',[1000 200 800 800], 'xtick',[],'ytick',[], 'box', 'on');
    
    %align([S.left S.right],'distribute','bottom');    
    set(gui.popProj,'callback',{@popProj_call, gui});  % Set the popup callback.
    set(gui.popSsn,'callback',{@popSsn_call, gui});  % Set the popup callback.
    set(gui.popCnd,'callback',{@popCnd_call, gui});  % Set the popup callback.
    
%     set(gui.pb, 'callback', {@pb_call, gui});
%     set(gui.edX,'call',{@edX_call, gui});  % Sharedclose all Callback.
%     set(gui.edY,'call',{@edY_call, gui});  % Sharedclose all Callback.
%     set(gui.edHX,'call',{@edHX_call, gui});  % Sharedclose all Callback.
%     set(gui.edHY,'call',{@edHY_call, gui});  % Sharedclose all Callback.
end

function [] = popProj_call(varargin)
% Callback for popupmenu.
    S = varargin{3};  % Get the structure.
    P = get(S.popProj, 'val'); % Get the users choice from the popup     
    S.currProj = S.projects{P};
    updateSsnList(S);
end    
function [] = popSsn_call(varargin)
% Callback for popupmenu.
    S = varargin{3};  % Get the structure.
    P = get(S.popSsn, 'val'); % Get the users choice from the popup     
    S.currSsn = S.sessions{P};
    if (~strcmp(S.currSsn, 'All'))
        updateCndList(S);
    end
end

function [] = popCnd_call(varargin)
% Callback for popupmenu.
    S = varargin{3};  % Get the structure.
    P = get(S.popCnd, 'val'); % Get the users choice from the popup     
    S.currCnd = S.conditions{P};
    cndData = loadConditionData(S);     
    displayCndInfo(S, cndData.info);
end

function updateSsnList(S)
    S.sessions = getSessionsList(fullfile(S.data, S.currProj));
    S.currSsn = S.sessions{S.default_pos};    
    updateCndList(S);
end
function updateCndList(S)
    if (~strcmp(S.currSsn, 'All'))
        S.conditions = getConditionsList(fullfile(S.data, S.currProj, S.currSsn));
        S.currCnd = S.conditions{S.default_pos};
        cndData = loadConditionData(S);     
        displayCndInfo(S, cndData.info); 
    end
end

function updateCallbacks(S)
% 
    set(S.popProj, 'callback', {@popProj_call, S});  % update the popup callback.    
    set(S.popSsn, 'callback', {@popProj_call, S});  % update the popup callback.    
    set(S.popCnd, 'callback', {@popProj_call, S});  % update the popup callback.    

%     set(S.edX, 'callback', {@edX_call, S});  % update the edit callback.
%     set(S.edHX, 'callback', {@edHX_call, S});  % update the edit callback.    
%     set(S.edY, 'callback', {@edY_call, S});  % update the edit callback.
%     set(S.edHY, 'callback', {@edHY_call, S});  % update the edit callback.    
%     set(S.pb, 'callback', {@pb_call, S});
end

function data = loadConditionData(S)
    if strcmp(S.currSsn, 'All')
    %load and average all data
    else
        dataSession = loadSession(fullfile(S.data, S.currProj, S.currSsn));
        data = dataSession{ismember(S.conditions, S.currCnd)};
    end
end

function displayCndInfo(S, data)
    uicontrol('style','text',...
                 'unit','normalized',...
                 'position',[0.05 0.45 0.2 0.2],...
                 'backgroundc',get(S.fh,'color'),...
                 'fontsize', 14, ...
                 'string', 'Condition Info','visible', 'on');
    
    list_fields = fields(data);
    % don't process the last 'display' field
    for f = 1:numel(list_fields) - 1
        % text
        uicontrol('style','text',...
                 'unit','normalized',...
                 'position',[0.05 0.45 - 0.03*f 0.2 0.2],...
                 'backgroundc',get(S.fh,'color'),...
                 'fontsize', 12, ...
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
                 'position',[0.2 0.45 - 0.03*f 0.2 0.2],...
                 'backgroundc',get(S.fh,'color'),...
                 'fontsize', 12, ...
                 'string', dataStr, 'visible', 'on');
    end
end

