function saveTrialData(session, cndInfo, nC, trials)

	if (~exist(session.saveDir, 'dir'))
		mkdir(session.saveDir)
    end
    saveStr = ['cnd' num2str(nC) 't1' num2str(cndInfo.nTrials) '.mat'];
    
	save(fullfile(session.saveDir, saveStr), 'cndInfo', 'trials');
end