function stimset = myStimset1(videoMode)
    % condition structure:
    % conditions.fhandle : function handle that will return dotFrames, dotColor and dotSize
    % conditions.fparams: arguments to function handle
    % conditions.info: stim info with the following fields:
    
    % info.nTrilas - # of repeats
    % info.cues
    % info.dynamic
    % info.direction
   
    
    % define simple stimset#2
    dotParamsName = 'defaultParams';
    dotParams = eval(dotParamsName);
    dotParams.cues = 'IOVD';                 
    dotParams.dynamics = {'ramp'};
    dotParams.direction = {{'right'}};
	dotParams.isPeriodic = 0;
	dotParams.trialRepeats = 1;
    
    allConditions = createConditions(dotParams);
    nc = numel(allConditions);
    stimset = cell(nc, 1);
    
    info1.cues =  dotParams.cues;
    info1.dynamics = dotParams.dynamics;
    info1.direction = dotParams.direction;
	info1.nTrials = dotParams.trialRepeats;
    
    
    for c = 1:nc
        stimset{c}.fhandle = 'generateDotFrames';
        stimset{c}.fparams = {allConditions{c}, videoMode};
        stimset{c}.info = info1;
    end 
end