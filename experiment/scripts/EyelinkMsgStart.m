function EyelinkMsgStart(stm, trial)
	% start recording for trial and inset flag with trial info
	
	
	display('Eyelink Recording Started');
	
	% mark zero-plot time in data file
	
	Eyelink('Message', ['STARTTIME ' stm.condition ' ' ...
		stm.dynamics ' ' stm.direction ' ' num2str(trial)]); 
end