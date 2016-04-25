function stimset = exampleStimset(videoMode)
    % condition structure:
    % conditions.fhandle : function handle that will return dotFrames, dotColor and dotSize
    % conditions.fparams: arguments to function handle
    % conditions.info: stim info with the following fields:
    
    % info.nTrilas - # of repeats
    % info.cues
    % info.dynamic
    % info.direction
   
    
    % define simple stimset#2
    dotParamsName = 'defaultStimset';
    dotParams = eval(dotParamsName);
    dotParams.cues = 'SingleDot';                 
    dotParams.dynamics = {{'step', 'ramp'}};
    dotParams.direction = {{'left', 'right'}};
	dotParams.isPeriodic = 0;
	dotParams.nTrials = 1;
    
    allConditions = createCombinations(dotParams);
    nc = numel(allConditions);
    stimset = cell(nc + 1, 1);
    
    info1.cues =  dotParams.cues;
    info1.dynamics = dotParams.dynamics;
    info1.direction = dotParams.direction;
	info1.nTrials = dotParams.nTrials;
    
    
    for c = 1:nc
        stimset{c}.fhandle = 'generateDotFrames';
        stimset{c}.fparams = {allConditions{c}, videoMode};
        stimset{c}.info = info1;
    end
    stimset{nc + 1}.fhandle = 'exampleMixedCondition';   
    stimset{nc + 1}.fparams = {videoMode};
    stimset{nc + 1}.info = exampleMixedCondition;  
end