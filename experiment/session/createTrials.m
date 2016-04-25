function trials = createTrials(cinfo)

    nTrials = cinfo.nTrials;    
 	trials.response    = cell(1, nTrials);
	trials.isOK   = zeros(1, length(nTrials));
    trials.conditions = cinfo.cues;
    trials.directions = cinfo.direction;
    trials.dynamics = cinfo.dynamics;
end