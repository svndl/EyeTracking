function [trialTiming, response] = runTrial(mySession, condition)

    if (~isfield(condition.info, 'name'))
       condition.info.name = condition.info.cues;
    end
    
    msgTrialDescription = [condition.info.name ':' ...
		condition.info.dynamics{:} ':'...
        condition.info.direction{:}];    
	
    display(msgTrialDescription);
    
    %% grab latest videoMode settings
    conditionViewMode = condition.fparams{2};
    
	%% pre-generate stimulus frames
    nDrawingParams = nargout(condition.fhandle);
    drawingParams = cell(nDrawingParams, 1);
    [drawingParams{:}] = feval(condition.fhandle, condition.fparams{:});
    noniusLines = getNoniusLines(condition.info.nonius, conditionViewMode);
    
    %% draw fixation
	drawFixation_Stereo(conditionViewMode);
	KeysWait(mySession.keys, mySession.recording);                                     
    
    if (~isfield(condition.info, 'drawHandle'))
        drawFun = str2func(drawDots);
    else
        drawFun = str2func(condition.info.drawHandle);
    end
        
    frameUpdate = round(mySession.scr.frameRate/condition.info.dotUpdateHz);
    if (mySession.recording)
        display('Eyelink Recording Started');
  		Eyelink('StartRecording');  
    end
    % generate prelude fix
    
    allFrames = generatePrelude(drawingParams{1}, condition.info);
    % run trial
	trialTiming = drawFun(allFrames, drawingParams{2:end}, conditionViewMode,...
        frameUpdate, noniusLines, msgTrialDescription);
    
    if (mySession.recording)
        display('Eyelink Recording Ended');
		Eyelink('StopRecording');
    end
    
	% clear screen at end
	drawTrialEndScreen(conditionViewMode);
    
	% get subject responses
	response = 'Mis';
    while mySession.keys.isDown == 0
		[mySession.keys, response] = KeysGetResponse(mySession.keys, mySession.recording);
    end
	mySession.keys.isDown = 0;
end