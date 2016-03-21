function saveTrialData(stm)
%
% store stimulus info, behavioral and eyetracking data

	if stm.recording
		Eyelink('CloseFile');
		eyelink_transfer_file(stm, 'tmp.edf', '_all_')
	end
	
		
	if (~exist(stm.paradigmDir, 'dir'))
		mkdir(stm.paradigmDir)
	end
	save(fullfile([stm.paradigmDir '.mat']), 'stm');
end