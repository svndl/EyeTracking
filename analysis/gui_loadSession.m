function gui_loadSession(varargin)
    close all;
    dirData = setPath;
    dataDir = dirData.data;
       
    if(~nargin)
        sessionPath = uigetdir(dataDir);
    else
        sessionPath = varargin{1};
    end
    data = loadSession(sessionPath);
    cndOKIdx = ~cellfun(@isempty, data);
    data = data(cndOKIdx);
    
    conditionsList = getConditionsList(sessionPath);
    
    conditionsList = conditionsList(cndOKIdx);
    conditionPos = 1;
    
    %make a gui
    guiSsn = guiLayout(sessionPath, conditionsList, conditionPos);
    
    % copy data fields
    guiSsn.data = data;
    % update all callbacks

    set(guiSsn.popCnd, 'callback', {@popCnd_call, guiSsn});
    set(guiSsn.pbPlot, 'callback', {@pbPlot_call, guiSsn});
    
    % display condition info
    dataOut = loadConditionData(guiSsn);
    displayCndInfo(guiSsn, dataOut.info);
end