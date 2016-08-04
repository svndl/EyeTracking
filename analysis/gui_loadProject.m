function gui_loadProject(varargin)
%% will load ONE selected project

    close all;
    dirData = setPath;
    dataDir = dirData.data;
       
    if(~nargin)
        dirname = uigetdir(dataDir);
        ProjectName = dirname;        
    else
        ProjectName = varargin{1};
    end
    
    data = loadProject(ProjectName);
    projPath = ProjectName;
    
    %lists for gui    
    sessionsList = getSessionsList(ProjectName);
    sessionsList{end + 1} = 'all';
    sessionPos = 1;
    
    conditionsList = getConditionsList(fullfile(projPath, sessionsList{sessionPos}));
    conditionPos = 1;
    
    %make a gui
    guiProj = guiLayout(ProjectName, conditionsList, conditionPos);
    
    % copy data fields
    guiProj.data = data;
    guiProj.projPath = projPath;
    guiProj.sessionsList = sessionsList;
    guiProj.sessionPos = sessionPos;

    
    % add to gui sessions
    uicontrol('parent', guiProj.fh, 'style','text',...
                 'unit','normalized',...
                 'position',[0.05 0.7 0.15 0.15],...
                 'backgroundc',get(guiProj.fh,'color'),...
                 'fontsize', 16, 'fontweight','bold',... 
                 'string', 'Sessions','visible', 'on');

    guiProj.popSsn  = uicontrol('parent', guiProj.fh, 'style', 'pop',...
                 'unit','normalized',...
                 'position',[0.05 0.67 0.15 0.15],...
                 'backgroundc',get(guiProj.fh,'color'),...
                 'fontsize',12,'fontweight','bold',... 
                 'string', guiProj.sessionsList,'value', guiProj.sessionPos);
                          
             
    % update all callbacks now    
    set(guiProj.popSsn, 'callback', {@popSsn_call, guiProj});
    set(guiProj.popCnd, 'callback', {@popCnd_call, guiProj});
    set(guiProj.pbPlot, 'callback', {@pbPlot_call, guiProj});
    
    % update condition info
    dataOut = loadConditionData(guiProj);
    displayCndInfo(guiProj, dataOut.info);
end
