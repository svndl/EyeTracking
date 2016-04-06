function runDotExperiment

    %% setup
    
    dotParamsName = 'defaultStimset';
    dotParams = eval(dotParamsName);
    
    display = 'planar';
    displayParams = eval(display);
    
    condition.cues = 'SingleDot';
    condition.dynamics = {{'step', 'ramp'}};
    condition.direction = {{'left', 'right'}};
	condition.isPeriodic = 0;
	condition.trialRepeats = 5;
    
    subject.name = 'Tester';
    subject.ipd = 6.5;    
    
 	useEyelink = 0;

	%% OLD CODE 
	
	directories = setPath;             
	timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');
	paradigmStr = 'TestingNewCode';
	
	%% Screen, Keyboard
    displayParams.white = 255;
    displayParams.gray = 127;
    displayParams.black = 0;
    
    
	videoMode = setupVideoMode_new(displayParams);     
    keys = KeysSetup;
	
    %session info
    %session = createSession(dotParams, displayParams, condition, subject, useEyelink);
	
	%% mkdir
	session.saveDir = fullfile(directories.data, paradigmStr, [subject.name timeStamp]);
	if (~exist(session.saveDir, 'dir'))
		mkdir(session.saveDir);
	end
   
    %% init experiment params (eyelink)
    updatedSession = inintExperiment(session, videoMode);
    
    %vary conditions ?? 
    allConditions = createConditions(dotParams);
    
    for s = 1:numel(allConditions)
		
		cndData = allConditions{s};
		cndData.timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');
		

		stm = calcStimsetParams(cndData, videoMode);   % stimulus properties		
		stm.recording = cndData.recording;
		
		trials = createTrials(stm);
		% Open file for recording
        
        if (stm.recording)
            Eyelink('Openfile', 'tmp.edf');				
        end
        
		for t = 1:stm.trialRepeats
			try 
				[trials.timing(t), trials.response{t}] = runTrial(t, stm, ...
					videoMode, keys);
				trials.isOK(t) = 1;
			catch err
				display('Ooops!');
				display(err.message);
				display(err.stack(1).file);
				display(err.stack(1).line);
							
				%drop this trial
				if (stm.recording)
					Eyelink('StopRecording');
				end
				trials.isOK(t) = 0;
			end
		end
		saveCondition(scr, stm, s, trials);
		drawConditionScr(s, allConditions, scr);
    end
    ExitSession(stm);
end

function updatedSession = inintExperiment(session, scr)
    
    updatedSession = session;
	if (updatedSession.recording)
		try
			if (EyelinkInitialize)
				el = EyelinkSetup(updatedSession, scr);  
				drawInitScreen(el, scr)    
	
				display('Experimenter press Space when cameras are ready');
			
				%slight delay before calibration/validation			
			
				KbWait;							
				WaitSecs(0.25);			
				EyelinkRunCalibration(updatedSession, scr, el)
			else
				%eyelink is not responding
				updatedSession.recording = 0;				
			end
		catch err
			display(err.message);
			display(err.stack(1).file);
			display(err.stack(1).line);
		end
    end

end

function [trialTiming, response] = runTrial(trialNum, stm, scr, keys)

	display(cell2mat(['trial ' num2str(trialNum) '/' num2str(length(stm.trialRepeats)) ' ' ...
		stm.condition ' ' stm.dynamics ' ... direction = ' stm.directions]))    
			
	%% pre-generate stimulus frames for this trial (and for the random delay period)
			
	[dotsLE, dotsRE] = generateDotFrames(scr, stm);
    
	%% initialize trial
	drawFixation(scr, 1);                
	KeysWait(keys, stm)                                     
		
	if (stm.recording) 
		Eyelink('StartRecording');  
	end
	isSaltPepper = 1;		
	%% show trial (with random delay first)
	trialTiming = drawTrial(trialNum, dotsLE, dotsRE, stm, scr, isSaltPepper);
            
	% clear screen at end
	drawTrialEndScreen(scr);
    
	% get subject responses
	response = 'Mis';
	while keys.isDown == 0
		[keys, response] = KeysGetResponse(keys, stm);
	end
	keys.isDown = 0;
end
function saveCondition(scr, stm, cnd, trials)
	stm.display_info    = scr;
	try
		if (stm.recording) 
			%transfer eyelink file and save
			EyelinkTransferFile(stm, 'tmp.edf', ['cnd' num2str(cnd)]);
		end
		saveTrialData(stm, cnd, trials);
	catch
		saveStr = strcat(stm.subj, '_', stm.timeStamp);
		display(['Could not save the session in requested folder, saving here as ' saveStr]);
		save([saveStr '.mat'], 'stm', 'trials');
	end
end

function drawConditionScr(cnd, ncnd, scr)
	%% display how much time left
	Screen('DrawText', scr.wPtr, ['Done block' num2str(cnd) ' of' num2str(numel(ncnd)) ' '], ...
		scr.xc_l - 25, scr.yc_l, scr.lwhite);
	Screen('Flip', scr.wPtr);
	WaitSecs(2);
end

