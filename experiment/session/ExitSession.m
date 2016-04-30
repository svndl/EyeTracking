function ExitSession(recording)
	if recording
		Eyelink('Shutdown');
	end
	sca;                   
	ListenChar(0);
	commandwindow;
end