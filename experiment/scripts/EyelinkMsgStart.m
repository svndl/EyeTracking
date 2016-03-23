function EyelinkMsgStart(stm, trial)
	% start recording for trial and inset flag with trial info
	
	
	display('Eyelink Recording Started');
	
	% mark zero-plot time in data file
	msgStr = ['STARTTIME ' stm.condition ' ' ...
		stm.dynamics ' ' stm.directions ' ' num2str(trial)];
	
	Eyelink('Message', char(msgStr)); 
end