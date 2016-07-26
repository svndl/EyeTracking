function trialSeq = getTrialSequence(conditions)
% function will return the initial sequence of trials
% Input parameters:
% conditions -- cell array of different conditions
% Output: 
% trialSeq = [mTrialsCondition1 ... mTrialsCndN] -- vector, where
% each element = nTrials per condition 

    nCnd = numel(conditions);
    ts = cell(nCnd, 1);
    for c = 1:nCnd
        ts{c} = c*ones(conditions{c}.info.nTrials, 1);
    end
    trialSeq = cell2mat(ts);
end