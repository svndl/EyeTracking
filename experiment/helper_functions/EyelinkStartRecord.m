function EyelinkStartRecord(condition, dynamics, direction, trial)
	% start recording for trial and inset flag with trial info
	
	
	display('Eyelink Recording Started');
	
	% mark zero-plot time in data file
	
	Eyelink('Message', ['STARTTIME ' condition ' ' ...
		dynamics ' ' direction ' ' num2str(trial)]); 
end