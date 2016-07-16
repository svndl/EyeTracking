function gui_loadSession(varargin)
    close all;
    dirData = setPath;
    gui.data = dirData.data;
    
    
    if(~nargin)
        dirname = uigetdir(gui.data);
        sessionPath = dirname;        
    else
        sessionPath = varargin{1};
    end
    gui.session = loadSession(sessionPath);
    
    %% conditions
    gui.conditions = getConditionsList(sessionPath);
    gui.cndPos = 1;
    gui.currCnd = gui.conditions{gui.cndPos};
 
    %% Conditions
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
          
%     uicontrol('style','text',...
%                  'unit','normalized',...
%                  'position',[0.05 0.8 0.2 0.2],...
%                  'backgroundc',get(gui.fh,'color'),...
%                  'fontsize', 16, 'fontweight','bold',... 
%                  'string', 'List of Projects','visible', 'on');
% 
%     gui.popProj = uicontrol('style','pop',...
%                  'unit','normalized',...
%                  'position',[0.05 0.75 0.2 0.2],...
%                  'backgroundc',get(gui.fh,'color'),...
%                  'fontsize',12,'fontweight','bold',... 
%                  'string', gui.projects, 'value', gui.projPos);
%     %% Subjects
%     uicontrol('style','text',...
%                  'unit','normalized',...
%                  'position',[0.05 0.7 0.2 0.2],...
%                  'backgroundc',get(gui.fh,'color'),...
%                  'fontsize', 16, 'fontweight','bold',... 
%                  'string', 'List of sessions','visible', 'on');
% 
%     gui.popSsn  = uicontrol('style','pop',...
%                  'unit','normalized',...
%                  'position',[0.05 0.65 0.2 0.2],...
%                  'backgroundc',get(gui.fh,'color'),...
%                  'fontsize',12,'fontweight','bold',... 
%                  'string', gui.sessions,'value', gui.ssnPos);
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
    
%     set(gui.popProj, 'callback', {@popProj_call, gui});  % Set the popup callback.
%     set(gui.popSsn, 'callback', {@popSsn_call, gui});  % Set the popup callback.
    set(gui.popCnd, 'callback', {@popCnd_call, gui});  % Set the popup callback.
    set(gui.pbPlot, 'callback', {@pb_call, gui});
end

% function [] = popProj_call(varargin)
% % Callback for Projects popupmenu.
%     S = varargin{3}; 
%     S.projPos = get(S.popProj, 'val');
%     S.currProj = S.projects{S.projPos};
%     updateSsnList(S);
% end    
% function [] = popSsn_call(varargin)
% % Callback for Sessions popupmenu.
%     S = varargin{3}; 
%     S.ssnPos = get(S.popSsn, 'val'); 
%     S.currSsn = S.sessions{S.ssnPos};
%     if (~strcmp(S.currSsn, 'all'))
%         updateCndList(S);
%     end
% end

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
%     S.currProj = S.projects{get(S.popProj, 'val')};
%     S.currSsn = S.sessions{get(S.popSsn, 'val')};
    S.currCnd = S.conditions{get(S.popCnd, 'val')};
        
    data = loadConditionData(S);
    stimPos = calcStimsetTrajectory(data.info);
    %get plot type
    set(0,'CurrentFigure', S.fh);
    
    set(S.fh,'CurrentAxes', S.left); 
    cla(S.left); 
    plot(-smooth(data.pos.Lavg(:, 1), 20), '-b'); hold on;
    plot(-smooth(data.pos.Ravg(:, 1), 20), '-r'); hold on;
    plot(-stimPos.l, '-ob'); hold on;
    plot(-stimPos.r, '-or'); hold on;
    
%     plot(-data.pos.Vergence(:, 1), '-.k'); hold on;
%     plot(-data.pos.Version(:, 1), '.k'); hold on;
    
    legend({'position L', 'position R', 'vergence', 'version'});
    
    set(S.fh,'CurrentAxes',S.right);
    cla(S.right);
    plot(-smooth(data.vel.Lavg(:, 1), 20), '-b'); hold on;
    plot(-smooth(data.vel.Ravg(:, 1), 20), '-r'); hold on;
    % mean velocity
%     plot(mean(data.vel.Lavg(251:end, 1), '.b')); hold on;
%     plot(mean(data.vel.Ravg(251:end, 1), '.r')); hold on;
    %plot(-data.vel.Vergence(:, 1), '-.k'); hold on;
    %plot(-data.vel.Version(:, 1), '.k'); hold on;
 %plot(data.info.rampSpeedDegSec*ones(size(data.vel.Vergence(:, 1), 1), 1), '-g');
    legend({'velocity L', 'velocity R', 'vergence velocity', 'version velocity'});
end
% function updateSsnList(S)
%     newSsnList = getSessionsList(fullfile(S.data, S.currProj));
%     % add 'all' session
%     S.sessions = [newSsnList {'all'}];
%     S.currSsn = S.sessions{S.ssnPos};    
%     updateCndList(S);
% end
% function updateCndList(S)
%     if (~strcmp(S.currSsn, 'all'))
%         S.conditions = getConditionsList(fullfile(S.data, S.currProj, S.currSsn));
%         S.currCnd = S.conditions{S.cndPos};
%         cndData = loadConditionData(S);     
%         displayCndInfo(S, cndData.info); 
%     end
%     %updateCallbacks(S);     
% end

function updateCallbacks(S)
%     set(S.popProj, 'callback', {@popProj_call, S}); 
%     set(S.popSsn, 'callback', {@popSsn_call, S});
%     set(S.popSsn, 'string', S.sessions);
%     set(S.popSsn, 'value',  S.ssnPos);
    set(S.popCnd, 'callback', {@popCnd_call, S});
    set(S.popCnd, 'string', S.conditions);
    set(S.pbPlot, 'callback', {@pb_call, S});
end

function dataOut = loadConditionData(S)
%     S.currProj = S.projects{get(S.popProj, 'val')};
%     S.ssnPos = get(S.popSsn, 'val');
%     S.currSsn = S.sessions{S.ssnPos};

        dataSession = S.session;
        dataOut = dataSession{S.cndPos};
        dataOut.info.missedFrames = dataOut.missedFrames;
        dataOut.info.samples = dataOut.samples;
end

function displayCndInfo(S, data)
    list_fields = fields(data);
    
    % don't process the last 'display' field
    for f = 1:numel(list_fields) - 3
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
