 function [conditions, trialCounter, stimSequence, runSequence] = setupStimulus(myScr, myStimset, varargin) 
% function  will prepare the session structure
%
%    
    if (~isempty(varargin)) 
        runSequence = varargin{1}{1};
        % extra argument is the number of slocks 
    else
        runSequence = 'cnd';
    end
         
    % do the trial/condition math
    conditions = feval(myStimset, myScr);
    trialSeq = getTrialSequence(conditions);
    nTrials = length(trialSeq);
    nCnd = numel(conditions);
    trialCounter = ones(nCnd, 1);
    
    %break in blocks
    switch (runSequence)        
        case 'cnd'
            %randomizeTrials = 0;            
            seq = trialSeq;
            nBlk = nCnd;
        case 'trl'
            %randomizeTrials = 1;            
            seq = trialSeq(randperm(nTrials));
            nBlk = nTrials;
        case 'blk'
            %randomizeTrials = 1;            
            seq = trialSeq(randperm(nTrials));
            nBlk = max(factor(nTrials)); 
    end
    stimSequence = reshape(seq, [nTrials/nBlk nBlk]);
 end