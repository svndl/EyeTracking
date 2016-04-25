function saveTrialData(session, cndInfo, nC, trials)
%
% store stimulus info, behavioral and eyetracking data

	if session.recording
		Eyelink('CloseFile');
		EyelinkTransferFile(session, 'tmp.edf', '_all_')
	end
	
		
	if (~exist(session.saveDir, 'dir'))
		mkdir(session.saveDir)
    end
    saveStr = ['cnd' num2str(nC) 't1' num2str(cndInfo.nTrials) '.mat'];
    
	save(fullfile(session.saveDir, saveStr), 'cndInfo', 'trials');
end