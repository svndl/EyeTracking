function session = createSession_new(dotParams, videoMode, conditions, subj, useEyelink)
	
    session.dotInfo = dotParams;
    session.subjInfo = subj;
	session.videoInfo = videoMode;

	session.cue = condition.cues;
    session.dynamics = condition.dynamics;
    session.directions = condition.directions;
    session.isPeriodic = conditions.isPeriodic;
    
    session.trialRepeats = conditions.trialRepeats;
	session.recording = useEyelink;
end