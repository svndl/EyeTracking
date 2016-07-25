function [trialTiming, response] = runTrial(mySession, condition)

    if (~isfield(condition.info, 'name'))
       condition.info.name = condition.info.cues;
    end
    
    msgTrialDescription = [condition.info.name ':' ...
		condition.info.dynamics{:} ':'...
        condition.info.direction{:}];    
	
    display(msgTrialDescription);
    
	%% pre-generate stimulus frames
    [dotFrames, dotColor, dotSize] = feval(condition.fhandle, condition.fparams{:});
    
    %% draw fixation
	drawFixation_Stereo(mySession.scr);
    
	KeysWait(mySession.keys, mySession.recording);                                     

    dotUpdate = round(mySession.scr.frameRate/condition.info.dotUpdateHz);
    if (mySession.recording)
        display('Eyelink Recording Started');
  		Eyelink('StartRecording');  
    end
    
	trialTiming = drawDots(dotFrames, dotColor, dotSize, mySession.scr, dotUpdate, condition.info.nonius, msgTrialDescription);
    if (mySession.recording)
        display('Eyelink Recording Ended');
		Eyelink('StopRecording');
    end
    
	% clear screen at end
	drawTrialEndScreen(mySession.scr);
    
	% get subject responses
	response = 'Mis';
    while mySession.keys.isDown == 0
		[mySession.keys, response] = KeysGetResponse(mySession.keys, mySession.recording);
    end
	mySession.keys.isDown = 0;
end