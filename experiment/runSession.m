function runSession

    
    %% Subject
    subject.name = 'Tester';
    subject.ipd = 6.5;    
 	useEyelink = 1;

    displayName = 'LG_OLED_TB';     
    paradigmStr = 'TowardsAwayAllCues';
    
    %% Setup session
    
    [mySession, myScr] = setupSession(displayName, subject, paradigmStr);
        
    %allStimsets = createConditions(mySession.stimset); 
    
    %% Inint session
    if (useEyelink)
        if (~initSession(mySession, myScr))
            useEyelink = 0;
        end
    end
    
    %% Conditions
    conditions = ta_TestSet(myScr);
    mySession.recording = useEyelink;
    
    %% run experiment 
    for s = 1:numel(conditions)
		
		mySession.timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');
		condition = conditions{s};
        
		trials = createTrials(condition.info);
		% Open file for recording
        
        if (useEyelink)
            Eyelink('Openfile', 'tmp.edf');				
        end
        
		for t = 1:condition.info.nTrials
			try 
				[trials.timing(t), trials.response{t}] = runTrial(t, myScr, ...
					mySession.keys, condition, useEyelink);
				trials.isOK(t) = 1;
			catch err
				display('Ooops!');
				display(err.message);
				display(err.stack(1).file);
				display(err.stack(1).line);
							
				%drop this trial
				if (useEyelink)
					Eyelink('StopRecording');
				end
				trials.isOK(t) = 0;
			end
		end
		saveCondition(mySession, condition.info, myScr, s, trials);
		drawConditionScr(s, numel(conditions), myScr);
    end
    ExitSession(useEyelink);
end
function [trialTiming, response] = runTrial(trialNum, scr, keys, condition, useEyelink)

    
    if (~isfield(condition.info, 'name'))
       condition.info.name = condition.info.cues;
    end
    
    msgDescription = cell2mat([{'trial ' num2str(trialNum) '/' num2str(condition.info.nTrials)} ' ' ...
		condition.info.name ' ' condition.info.dynamics{:} ' ... direction = ' condition.info.direction{:}]);    
	
    display(msgDescription);
    
	%% pre-generate stimulus frames for this trial (and for the random delay period)
	
    [dotFrames, dotColor, dotSize] = feval(condition.fhandle, condition.fparams{:});
    %% initialize trial
	drawFixation(scr, 1, 0);
	drawFixation(scr, 1, 1);
    
	KeysWait(keys, useEyelink);                                     

    dotUpdate = scr.frameRate/condition.info.dotUpdateHz;
		
	if (useEyelink)
        display('Eyelink Recording Started');
    
        condition.info.msgEyelink = ['STARTTIME ' condition.info.name ':' ...
		condition.info.dynamics{:} ':'...
        condition.info.direction{:} ':' num2str(trialNum)];
    
        Eyelink('Message',  condition.info.msgEyelink);
		Eyelink('StartRecording');  
    end
    
	trialTiming = drawDots(dotFrames, dotColor, dotSize, scr, dotUpdate);

	if (useEyelink)
        display('Eyelink Recording Ended');        
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
function saveCondition(sessionInfo, conditionInfo, scr, nC, trials)
	conditionInfo.display_info    = scr;
	try
		if (sessionInfo.recording) 
			%transfer eyelink file and save
			EyelinkTransferFile(sessionInfo, 'tmp.edf', ['cnd' num2str(nC)]);
		end
		saveTrialData(sessionInfo, conditionInfo, nC, trials);
	catch
		saveStr = strcat(sessionInfo.subj, '_', sessionInfo.timeStamp);
		display(['Could not save the session in requested folder, saving here as ' saveStr]);
		save([saveStr '.mat'], 'conditionInfo', 'trials');
	end
end

function drawConditionScr(cnd, ncnd, scr)
	%% display how much time left
	Screen('DrawText', scr.wPtr, ['Done block' num2str(cnd) ' of ' num2str(ncnd) ' '], ...
		scr.xc_l - 25, scr.yc_l, scr.lwhite);
	Screen('Flip', scr.wPtr);
	WaitSecs(2);
end
