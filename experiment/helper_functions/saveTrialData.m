function saveTrialData(stm)
%
% store stimulus info, behavioral and eyetracking data

	if stm.recording
		Eyelink('CloseFile');
		EyelinkTransferFile(stm, 'tmp.edf', '_all_')
	end
	
		
	if (~exist(stm.saveDir, 'dir'))
		mkdir(stm.saveDir)
	end
	save(fullfile([stm.paradigmDir filesep '.mat']), 'stm');
end