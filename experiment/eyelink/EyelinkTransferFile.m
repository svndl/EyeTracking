function EyelinkTransferFile(saveDirPath, fileName)
    ListenChar(0);
    Eyelink('SetOfflineMode');
    Eyelink('WaitForModeReady', 500);
    try
        fprintf('Receiving data file ''%s''\n', fileName );
		%data file
        location = [saveDirPath filesep fileName '.edf'];
		status = Eyelink('ReceiveFile', [fileName '.edf'], location);
        if(status > 0)
            fprintf('ReceiveFile status %d\n', status);
            %command = ['edf2asc -sh ' location];
            %[~, ~] = system(command);
        end
    % ESC_KEY  = hex2dec('001B')
    % ENTER_KEY = hex2dec('000D')
    % JUNK_KEY = 1;
    % Eyelink('SendKeyButton', 'KB_BUTTON', , 'KB_PRESS')        
    catch
        % try to save file here
        Eyelink('ReceiveFile', fileName);        
		fprintf('Problem receiving data file ''%s''\n', fileName );
    end
    %GetChar();
end