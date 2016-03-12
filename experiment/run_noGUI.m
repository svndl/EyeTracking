function run_noGUI

	stimsetName = 'defaultStimset';		
	stimsetParams = eval(stimsetName);
		
	%videoMode info
	videoDisplay = 'planar';
	videoMode = getVideoMode(videoDisplay);
		
		% experiment params
	conditions.cues = {'CDOT', 'IOVD'};
	conditions.directions = {'left', 'right'};
	conditions.dynamics = {'ramp'};
		
	subj.name = 'Tester';
	subj.ipd = 6.5;
	
	useEyelink = 0;
	session = createSession(stimsetParams, videoMode, conditions, subj, useEyelink);
	
	%% OLD CODE 
	
	session.directories = setPath;             
	session.timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');
	session.paradigmStr = 'TestingNewGui';
	[scr, w, ~]   = screen_setup(videoMode);     
	[session, keys]   = keys_setup(session);
	

	
	if (session.recording)
		try
			if (eyelink_init_connection)
				el = eyelink_setup(session, w, scr);  
				screen_draw_intro(el, scr, w)    
	
				display('Experimenter press Space when cameras are ready');
			
				%slight delay before calibration/validation			
			
				KbWait;							
				WaitSecs(0.25);			
				eyelink_run_calibration(session, scr, el)
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
		dat = dataCombs{s};
		dat.timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');

		
		% RUN TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
		[dat, scr, stm] = stimulus_setup(dat, scr);   % stimulus properties

		for t = 1:length(dat.trials.trialnum)                   % for each trial
    
			% trial info
			trial           = dat.trials.trialnum(t);           % which stimulus index to take
			condition       = dat.trials.condition{trial};      % condition
			dynamics        = dat.trials.dynamics{trial};       % dynamics
			direction       = dat.trials.direction{trial};      % towards, away, left, right
			delay           = dat.trials.delayUpdates(trial);   % number of dot updates to delay before prelude
			display(['trial ' num2str(t) '/' num2str(length(dat.trials.trialnum)) ' ' ...
				condition ' ' dynamics ' ... direction = ' direction ...
				'params = ' dat.paradigmParamsStr]);
    
    
			% pre-generate stimulus frames for this trial (and for the random delay period)
			[dotsLE, dotsRE]   = stimulus_pregenerate_trial(scr, stm, condition, dynamics, direction, delay);
    
    
			% initialize trial
			stimulus_draw_fixation(w,scr,dat,stm,1);                % static fixation pattern before stimulus
			keys_wait(keys,dat)                                     % subject starts trials
		
		
			if (dat.recording) 
				Eyelink('StartRecording');  
			end       
			% show trial (with random delay first)
			dat = stimulus_draw_trial(w, trial, dotsLE, dotsRE, dat, stm, scr, condition, dynamics, direction, delay);
    
    
			% clear screen at end
			stimulus_draw_end_screen(w, scr);
    
    
			% get subject responses
			while keys.isDown == 0
				[dat,keys] = keys_get_response(keys,dat,stm,trial,direction);
			end
			keys.isDown = 0;
    
		end

		% aggregate and save data structures
		dat.keys            = keys;
		dat.display_info    = scr;
		dat.stim_info       = stm;
		try
			store_results(dat);
		catch
			saveStr = strcat(dat.subj, '_', dat.timeStamp);
			display(['Could not save the session in requested folder, saving here as ' saveStr]);
			save([saveStr '.mat'], 'dat');
		end
		% exit
		%Screen('DrawText', w, 'Done', scr.x_center_pix_right - 25, scr.y_center_pix_right - 50, dat.stim_info.REwhite);
		Screen('DrawText', w, ['Done block' num2str(s) ' of' num2str(numel(dataCombs)) ' '], ...
			scr.x_center_pix_left - 25, scr.y_center_pix_left, scr.LEwhite);
		Screen('Flip', w);
		WaitSecs(2);
	end
	cleanup(0, dat);	
end

function scr = getVideoMode(displayName)
	scr = eval(displayName);
	
	scr.wlevel = 255;       
	scr.glevel = 0;          
	scr.blevel = 0;         

	switch displayName
    
		case {'planar','laptopRB','LG3DRB','CinemaDisplayRB'}       % planar uses blue-left, red-right
        
			scr.REwhite = [scr.glevel scr.glevel scr.wlevel];
			scr.REblack = [scr.glevel scr.glevel scr.blevel];
        
			scr.LEwhite = [scr.wlevel scr.glevel scr.glevel];
			scr.LEblack = [scr.blevel scr.glevel scr.glevel];
        
		otherwise                                                   % other displays just use white/black
        
			scr.LEwhite = [scr.wlevel scr.wlevel scr.wlevel];
			scr.LEblack = [scr.blevel scr.blevel scr.blevel];
        
			scr.REwhite = [scr.wlevel scr.wlevel scr.wlevel];
			scr.REblack = [scr.blevel scr.blevel scr.blevel];
        
	end
	
end

function data = createSession(stimset, videoMode, conditions, subj, useEyelink)
	
	data = stimset;

	data.ipd = subj.ipd;
	data.subj = subj.name;	

	data.conditions = conditions.cues;
	data.dynamics = conditions.dynamics;
	data.directions = conditions.directions;
	data.display = videoMode.name;
	
	data.recording = useEyelink;		
end

function dataCombs = createTrialStructure(data)

	
	%stimset numerical combvec
	columnLabels = {'stimRadDeg', 'dispArcmin', 'rampSpeedDegSec', 'dotSizeDeg', 'dotDensity', 'cycleSec'};
	cartesianTrialProd = combvec(data.stimRadDeg, data.dispArcmin, data.rampSpeedDegSec, data.dotSizeDeg, data.dotDensity, data.cycleSec)';
	
	nDataCombs = size(cartesianTrialProd, 1);
	dataCombs = cell(nDataCombs, 1);
		
	for dn = 1: nDataCombs
		copyData = data;
		for fn = 1:numel(columnLabels);
			copyData.(columnLabels{fn}) = cartesianTrialProd(dn, fn);
		end
		
		%big-ass string
		allStr = strcat(columnLabels', ...
			repmat('=', size(columnLabels, 2), size(columnLabels, 1)), ...
			repmat(':', size(columnLabels, 2), size(columnLabels, 1)), ...
			num2str(cartesianTrialProd(dn , 1:end)'));
		
		copyData.paradigmParamsStr = strcat(allStr{:});
		dataCombs{dn} = copyData;
	end
end
