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
   
    %% 

end



