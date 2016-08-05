function exportSessionData(varargin)
% Function takes a full path to session and exports raw and processed data
% in matfile format 
% export data structure: 
% cndxInfo.mat -- condition info
% for a given condition x and trial y: 
% raw_cndx_ty.mat -- raw data matrix (time, Lx,  Ly, Rx, Ry)
% pos_cndx.mat -- processed position average data (L, R, vergence, version)
% vel_cndx.mat -- processed velocity average data (L, R, vergence, version)
    myPath = setPath;
    
    if (~isempty(varargin))
        sessionData = varargin{1};
        exportDir = varargin{2};
    else
        exportDir = uigetdir('Select session folder', myPath.data);
        sessionData = loadSession(exportDir);
    end
    
    nC = numel(sessionData);
    for c = 1:nC
        condition = sessionData{c};
        cndInfo = condition.info;
        cndPos = condition.pos;
        cndVel = condition.vel;
        cndTiming = condition.timing;
        
        fileCndInfo = sprintf('cnd_%dInfo.mat', c);
        fileCndPos = sprintf('pos_cnd%d.mat', c);
        fileCndVelo = sprintf('vel_cnd%d.mat', c);
        fileCndTiming = sprintf('vel_cnd%d.mat', c);        
        
        save(fullfile(exportDir, fileCndInfo), 'cndInfo');
        save(fullfile(exportDir, fileCndPos), 'cndPos');
        save(fullfile(exportDir, fileCndVelo), 'cndVel');
        save(fullfile(exportDir, fileCndTiming), 'cndTiming');
    end
end