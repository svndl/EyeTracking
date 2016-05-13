function exportSessionData(sessionData, exportDir)
% Function takes a full path to session and exports raw and processed data
% in matfile format 
% export data structure: 
% cndxInfo.mat -- condition info
% for a given condition x and trial y: 
% raw_cndx_ty.mat -- raw data matrix (time, Lx,  Ly, Rx, Ry)
% pos_cndx.mat -- processed position average data (L, R, vergence, version)
% vel_cndx.mat -- processed velocity average data (L, R, vergence, version)
    
    nC = numel(sessionData);
    for c = 1:nC
        condition = sessionData{c};
        cndInfo = condition.info;
        cndPos = condition.pos;
        cndVel = condition.vel;
        fileCndInfo = sprintf('cnd_%dInfo.mat', c);
        fileCndPos = sprintf('pos_cnd%d.mat', c);
        fileCndVelo = sprintf('vel_cnd%d.mat', c);
        
        save(fullfile(exportDir, fileCndInfo), 'cndInfo');
        save(fullfile(exportDir, fileCndPos), 'cndPos');
        save(fullfile(exportDir, fileCndVelo), 'cndVel');
        
        %save raw trial data
        nT = numel(condition.data);
        
        for t = 1:nT
           trialData = condition.data{t};
           fileCndTrial = sprintf('Raw_cnd%d_t%d.mat', c, t);
           save(fullfile(exportDir, fileCndTrial), 'trialData');
        end

    end
end