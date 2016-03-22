function saveTrialData(stm, cnd, trials)
%
% store stimulus info, behavioral and eyetracking data

	if stm.recording
		Eyelink('CloseFile');
		EyelinkTransferFile(stm, 'tmp.edf', '_all_')
	end
	
		
	if (~exist(stm.saveDir, 'dir'))
		mkdir(stm.saveDir)
    end
    saveStr = ['cnd' num2str(cnd) 't1' num2str(stm.trialRepeats) '.mat'];
    
	save(fullfile(stm.saveDir, saveStr), 'stm', 'trials');
end