% Cleanup routine:
function ExitSession(recording)
	if recording
		Eyelink('Shutdown');    % Shutdown Eyelink:
	end
	sca;                    % Close window:
	ListenChar(0);          % Restore keyboard output to Matlab:
    warning('Exited experiment before completion');
	clear all;
	commandwindow;
end