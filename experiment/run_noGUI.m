function run_noGUI

	stimsetName = 'defaultStimset';		
	stimsetParams = eval(stimsetName);
		
	%videoMode info
	videoDisplay = 'planar';
	videoMode = getVideoMode(videoDisplay);
		
		% experiment params
	%one/many dots
	conditions.cues = {'SingleDot'};
	conditions.dynamics = {{'step', 'ramp'}};
	%for each dynamics, define directions	
	conditions.directions = {{'right', 'right'}};
	conditions.isPeriodic = 0;
	conditions.trialRepeats = 2;      % number of repeats per condition
		
	subj.name = 'Tester';
	subj.ipd = 6.5;
	
	useEyelink = 1;
	session = createSession(stimsetParams, videoMode, conditions, subj, useEyelink);
	
	%% OLD CODE 
	
	session.directories = setPath;             
	session.timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');
	session.paradigmStr = 'TestingNewCode';
	
	%% Screen, Keyboard
	[scr, w, ~]   = setupVideoMode(videoMode);     
	keys = KeysSetup;
	
	
	%% mkdir
	session.saveDir = fullfile(session.directories.data, session.paradigmStr, [subj.name session.timeStamp]);
	if (~exist(session.saveDir, 'dir'))
		mkdir(session.saveDir);
	end
	

	if (session.recording)
		try
			if (EyelinkInitialize)
				el = EyelinkSetup(session, w, scr);  
				drawInitScreen(el, scr, w)    
	
				display('Experimenter press Space when cameras are ready');
			
				%slight delay before calibration/validation			
			
				KbWait;							
				WaitSecs(0.25);			
				EyelinkRunCalibration(session, scr, el)
			else
				%eyelink is not responding
				session.recording = 0;				
			end
		catch
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
		% for each trial		
		for t = 1:stm.trialRepeats                 
    
			display(['trial ' num2str(t) '/' num2str(length(stm.trialRepeats)) ' ' ...
				stm.condition ' ' stm.dynamics ' ... direction = ' stm.directions])    
			
            
            
			%% pre-generate stimulus frames for this trial (and for the random delay period)
			
			[dotsLE, dotsRE] = generateDotFrames(scr, stm, trials.delayFrames(t));
    
			%% initialize trial
			drawFixation(w, scr, 1);                
			KeysWait(keys, stm)                                     
		
			if (stm.recording) 
				Eyelink('Openfile', 'tmp.edf');				
				Eyelink('StartRecording');  
			end
			
			%% show trial (with random delay first)
			trialTiming = drawTrial(w, t, dotsLE, dotsRE, stm, scr, trials.delayFrames(t));
            trials.timing(t) = trialTiming;
            
			% clear screen at end
			drawTrialEndScreen(w, scr);
    
    		if (stm.recording) 
				%transfer eyelink file and save
				EyelinkTransferFile(stm, 'tmp.edf', ['_' 'cnd' num2str(s)]);
			end

			% get subject responses
			while keys.isDown == 0
				[keys, response] = KeysGetResponse(keys, stm);
                trials.response{t} = response;
                
			end
			keys.isDown = 0;
    
		end

		% aggregate and save data structures
		stm.keys            = keys;
		stm.display_info    = scr;
		
		try
			saveTrialData(stm, s, trials);
		catch
			saveStr = strcat(cndData.subj, '_', cndData.timeStamp);
			display(['Could not save the session in requested folder, saving here as ' saveStr]);
			save([saveStr '.mat'], 'stm');
		end
		% display how much time left
		Screen('DrawText', w, ['Done block' num2str(s) ' of' num2str(numel(allConditions)) ' '], ...
			scr.x_center_pix_left - 25, scr.y_center_pix_left, scr.LEwhite);
		Screen('Flip', w);
		WaitSecs(2);
    end
    ExitSession(stm);
end

