function EyelinkTransferFile(stm, edfFile, fileStr)

    
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
	
		filename = [stm.saveDir filesep fileStr '.edf'];
		try
			movefile(edfFile, filename);
		catch
			
			display('Unable to move the eyelink file, saving as ');
			filename = [datestr(clock,'mm_dd_yy_HHMMSS') '.edf'];
			movefile(edfFile, filename);
		end
		command = ['edf2asc -sh ' filename];
		[~, ~] = system(command);
	end
end