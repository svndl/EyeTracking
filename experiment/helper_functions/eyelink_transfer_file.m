function eyelink_transfer_file(dat, edfFile, fileStr)

    
	if ~isempty(edfFile)
		try
			fprintf('Receiving data file ''%s''\n', edfFile );
			%data file
			status = Eyelink('ReceiveFile');
        
			if status > 0
				fprintf('ReceiveFile status %d\n', status);
			end
			if (exist(edfFile, 'file') == 2)
				fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
			end
		catch
			fprintf('Problem receiving data file ''%s''\n', edfFile );
		end
    
		%move and convert file
	
		filename = fullfile(dat.directories.data, dat.paradigmStr, [dat.subj fileStr dat.timeStamp '.edf']);
		try
			movefile(edfFile, filename);
		catch
			movefile(edfFile, [dat.subj fileStr dat.timeStamp '.edf']);
		end
		command = ['/Applications/EyeLink/edfapi\ universal/edf2asc -sh ' filename];
		[~, ~] = system(command);
	end
end