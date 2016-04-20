function data = createSession(stimset, videoMode, conditions, subj, useEyelink)
	
	data = stimset;

	data.ipd = subj.ipd;
	data.subj = subj.name;	

	data.condition = conditions.cues;
	data.dynamics = conditions.dynamics;
	data.directions = conditions.directions;
	data.isPeriodic = conditions.isPeriodic;
	data.display = videoMode.name;
    data.trialRepeats = conditions.trialRepeats;
	
	data.recording = useEyelink;		
end
