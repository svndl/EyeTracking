function trials = createTrials(stm)

    nTrials = stm.trialRepeats;
    trials.delaySec = 1e-03*randi([250, 750], 1, nTrials);
    trials.delayFrames = round(trials.delaySec./stm.dotUpdateSec);
    trials.delayUpdates = round(stm.dotUpdateHz.*trials.delaySec);
    
 	trials.response    = cell(1, nTrials);
	trials.isCorrect   = zeros(1, length(nTrials));
    trials.conditions = stm.condition;
    trials.directions = stm.directions;
    trials.dynamics = stm.dynamics;
    trials.isPeriodic = stm.isPeriodic;
end