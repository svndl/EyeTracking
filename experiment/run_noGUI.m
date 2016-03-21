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
	conditions.directions = {{'right', 'left'}};
	conditions.motiontype = {'periodic'};
		
	subj.name = 'Tester';
	subj.ipd = 6.5;
	
	useEyelink = 0;
	session = createSession(stimsetParams, videoMode, conditions, subj, useEyelink);
	
	%% OLD CODE 
	
	session.directories = setPath;             
	session.timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');
	session.paradigmStr = 'TestingNewGui';
	
	%% Screen, Keyboard
	[scr, w, ~]   = setupVideoMode(videoMode);     
	[session, keys] = keys_setup(session);
	
	
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
				Eyelink('Openfile', 'tmp.edf');
			else
				%eyelink is not responding
				session.recording = 0;				
			end
		catch
		end
	end
	
	
	%update dat.paradigm
	dataCombs = createTrialStructure(session);
	
	
	for s = 1:numel(dataCombs)
		
		sessionData = dataCombs{s};
		sessionData.timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');
		

		stm = setupStimSession(sessionData, scr);   % stimulus properties		
		stm.recording = sessionData.recording;
		
		
		% for each trial		
		for t = 1:stm.nTrials                 
    
			display(['trial ' num2str(t) '/' num2str(length(stm.nTrials)) ' ' ...
				stm.condition ' ' stm.dynamics ' ... direction = ' stm.directions])    
			
			delay = (1e-03*randi([250, 750])/stm.dotUpdateSec);
    
			%% pre-generate stimulus frames for this trial (and for the random delay period)
			
			[dotsLE, dotsRE]   = generateDotFrames(scr, stm, delay);
    
			%% initialize trial
			drawFixation(w, scr, stm, 1);                
			keys_wait(keys, stm)                                     
		
		
			if (stm.recording) 
				Eyelink('StartRecording');  
			end
			
			%% show trial (with random delay first)
			runTrial(w, trial, dotsLE, dotsRE, stm, scr);
    
			% clear screen at end
			drawTrialEndScreen(w, scr);
    
    
			% get subject responses
			while keys.isDown == 0
				[stm,keys] = keys_get_response(keys, stm, trial, direction);
			end
			keys.isDown = 0;
    
		end

		% aggregate and save data structures
		stm.keys            = keys;
		stm.display_info    = scr;
		
		try
			saveTrialData(stm);
		catch
			saveStr = strcat(sessionData.subj, '_', sessionData.timeStamp);
			display(['Could not save the session in requested folder, saving here as ' saveStr]);
			save([saveStr '.mat'], 'stm');
		end
		% display how much time left
		Screen('DrawText', w, ['Done block' num2str(s) ' of' num2str(numel(dataCombs)) ' '], ...
			scr.x_center_pix_left - 25, scr.y_center_pix_left, scr.LEwhite);
		Screen('Flip', w);
		WaitSecs(2);
	end
	cleanup(0, stm);	
end

