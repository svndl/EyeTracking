function run_noGUI

	stimsetName = 'defaultStimset';		
	stimsetParams = eval(stimsetName);
		
	%videoMode info
	videoDisplay = 'laptop';
	videoMode = getVideoMode(videoDisplay);
		
		% experiment params
	%one/many dots
	conditions.cues = {'IOVD'};
	conditions.dynamics = {{'ramp'}};
	%for each dynamics, define directions	
	conditions.directions = {{'right'}};
	conditions.isPeriodic = 0;
	conditions.trialRepeats = 5;      % number of repeats per condition
		
	subj.name = 'Tester';
	subj.ipd = 6.5;
	
	useEyelink = 0;
	session = createSession(stimsetParams, videoMode, conditions, subj, useEyelink);
	
	%% OLD CODE 
	
	session.directories = setPath;             
	session.timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');
	session.paradigmStr = 'TestingNewCode';
	
	%% Screen, Keyboard
    videoMode.background = [127 127 127];    
	scr  = setupVideoMode(videoMode);     
	keys = KeysSetup;
	
	
	%% mkdir
	session.saveDir = fullfile(session.directories.data, session.paradigmStr, [subj.name session.timeStamp]);
	if (~exist(session.saveDir, 'dir'))
		mkdir(session.saveDir);
	end
	

	if (session.recording)
		try
			if (EyelinkInitialize)
				el = EyelinkSetup(session, scr);  
				drawInitScreen(el, scr)    
	
				display('Experimenter press Space when cameras are ready');
			
				%slight delay before calibration/validation			
			
				KbWait;							
				WaitSecs(0.25);			
				EyelinkRunCalibration(session, scr, el)
			else
				%eyelink is not responding
				session.recording = 0;				
			end
		catch err
			display(err.message);
			display(err.stack(1).file);
			display(err.stack(1).line);
		end
	end
	
	
	%update dat.paradigm
	allConditions = createConditions(session);
    
    for s = 1:numel(allConditions)
		
		cndData = allConditions{s};
		cndData.timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');
		

		stm = calcStimsetParams(cndData, scr);   % stimulus properties		
		stm.recording = cndData.recording;
		
		trials = createTrials(stm);
		% Open file for recording
        
        if (stm.recording)
            Eyelink('Openfile', 'tmp.edf');				
        end
        
		for t = 1:stm.trialRepeats
			try 
				[trials.timing(t), trials.response{t}] = runTrial(t, stm, ...
					scr, keys);
				trials.isOK(t) = 1;
			catch err
				display('Ooops!')
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
		scr.x_center_pix_left - 25, scr.y_center_pix_left, scr.LEwhite);
	Screen('Flip', scr.wPtr);
	WaitSecs(2);
end
