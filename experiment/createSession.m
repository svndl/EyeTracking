function data = createSession(stimset, videoMode, conditions, subj, useEyelink)
	
	data = stimset;

	data.ipd = subj.ipd;
	data.subj = subj.name;	

	data.conditions = conditions.cues;
	data.dynamics = conditions.dynamics;
	data.directions = conditions.directions;
	data.motiontype = conditions.motiontype;
	data.display = videoMode.name;
	
	data.recording = useEyelink;		
end
