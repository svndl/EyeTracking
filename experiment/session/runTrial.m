function [trialTiming, response] = runTrial(trialNum, scr, keys, condition, useEyelink)

    if (~isfield(condition.info, 'name'))
       condition.info.name = condition.info.cues;
    end
    
    msgTrialDescription = [condition.info.name ':' ...
		condition.info.dynamics{:} ':'...
        condition.info.direction{:} ':' num2str(trialNum)];    
	
    display(msgTrialDescription);
    
	%% pre-generate stimulus frames
    [dotFrames, dotColor, dotSize] = feval(condition.fhandle, condition.fparams{:});
    
    %% draw fixation
	drawFixation_Stereo(scr, 1);
    
	KeysWait(keys, useEyelink);                                     

    dotUpdate = scr.frameRate/condition.info.dotUpdateHz;
    if (useEyelink)
        display('Eyelink Recording Started');
        
        condition.info.msgEyelinkStart = ['STARTTIME:' num2str(GetSecs) ':' msgTrialDescription];
    
        Eyelink('Message',  condition.info.msgEyelinkStart);
		Eyelink('StartRecording');  
    end
    
	trialTiming = drawDots(dotFrames, dotColor, dotSize, scr, dotUpdate, condition.info.nonius);
    if (useEyelink)
        display('Eyelink Recording Ended');
        %add stop message?
        condition.info.msgEyelinkStop = ['STOPTTIME:' num2str(GetSecs) ':' msgTrialDescription];
        Eyelink('Message',  condition.info.msgEyelinkStop);
		Eyelink('StopRecording');
    end
    
	% clear screen at end
	drawTrialEndScreen(scr);
    
	% get subject responses
	response = 'Mis';
    while keys.isDown == 0
		[keys, response] = KeysGetResponse(keys, useEyelink);
    end
	keys.isDown = 0;
end