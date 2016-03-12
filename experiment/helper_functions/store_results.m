function store_results(dat)
%
% store stimulus info, behavioral and eyetracking data

	if dat.recording
		Eyelink('CloseFile');
		eyelink_transfer_file(dat,'tmp.edf','_all_')
	end
	
	
	paradigmDir = fullfile(dat.directories.data, dat.paradigmStr, [dat.subj dat.timeStamp]);
	
	if (~exist(paradigmDir, 'dir'))
		mkdir(paradigmDir)
	end
	save(fullfile([paradigmDir '.mat']), 'dat');
end