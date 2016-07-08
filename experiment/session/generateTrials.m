function [trials, cndSequence] = generateTrials(conditions)

% function will generate trials
% Input parameters:
% conditions -- cell array of different conditions

% trials is a cell vector
    nCnd = numel(conditions);
    totalTrials = 0;
    for c = 1:nCnd
        totalTrials = totalTrials + conditions{c}.info.nTrials;
    end
        
    trials = cell(totalTrials, 1); 
    cndSequence = zeros(totalTrials, 1);
    nc = 1;
    trialCount = 1;
    while nc <= nCnd
        cnd = conditions{c};
        nTrials = cnd.info.nTrials;
        nt = 1;
        while nt <= nTrials
            trials{trialCount} =  feval(cnd.fhandle,cnd.fparams{:});
            cndSequence(trialCount) = nc;
            nt = nt + 1;
            trialCount = trialCount + 1;
        end
        nc = nc + 1;
    end
end