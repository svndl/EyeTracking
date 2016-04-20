function conditions = myConditions(videoMode)
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
	dotParams.trialRepeats = 1;
    
    allConditions = createConditions(dotParams);
    nc = numel(allConditions);
    conditions = cell(nc + 1, 1);
    
    info1.cues =  dotParams.cues;
    info1.dynamics = dotParams.dynamics;
    info1.direction = dotParams.direction;
	info1.nTrials = dotParams.trialRepeats;
    
    
    for c = 1:nc
        conditions{c}.fhandle = 'generateDotFrames';
        conditions{c}.fparams = {allConditions{c}, videoMode};
        conditions{c}.info = info1;
    end
    conditions{nc + 1}.fhandle = 'createMixedStimset';   
    conditions{nc + 1}.fparams = {videoMode};
    conditions{nc + 1}.info = createMixedStimset;  
end