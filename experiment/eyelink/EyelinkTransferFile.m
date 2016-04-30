function EyelinkTransferFile(saveDirPath, fileName)
    Eyelink('CloseFile');
    % Restore keyboard output to Matlab:    
    ListenChar(0);          
    try
        fprintf('Receiving data file ''%s''\n', fileName );
		%data file
        location = [saveDirPath filesep fileName '.edf'];
		status = Eyelink('ReceiveFile', [fileName '.edf'], location);
        if(status > 0)
            fprintf('ReceiveFile status %d\n', status);
            command = ['edf2asc -sh ' location];
            [~, ~] = system(command);
        end
    catch
        % try to save file here
        Eyelink('ReceiveFile', fileName);        
		fprintf('Problem receiving data file ''%s''\n', fileName );
    end
end