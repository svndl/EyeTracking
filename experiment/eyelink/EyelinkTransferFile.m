function EyelinkTransferFile(session, edfFile, fileStr)
    Eyelink('CloseFile');
    
    try
        fprintf('Receiving data file ''%s''\n', edfFile );
		%data file
        location = [session.saveDir filesep fileStr '.edf'];
		status = Eyelink('ReceiveFile', edfFile, location);
        
		if (status > 0)
            fprintf('ReceiveFile status %d\n', status);
            command = ['edf2asc -sh ' location];
            [~, ~] = system(command);
        end
	catch
		fprintf('Problem receiving data file ''%s''\n', edfFile );
    end
end