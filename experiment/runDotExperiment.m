function runDotExperiment

    %% setup
    
    dotParamsName = 'defaultDotParams';
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
	
    %session info
    session = createSession(dotParams, displayParams, condition, subject, useEyelink);
	
	%% OLD CODE 
	
	directories = setPath;             
	timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');
	paradigmStr = 'TestingNewCode';
	
	%% Screen, Keyboard
    displayParams.background = [127 127 127];    
	videoMode = setupVideoMode(displayParams);     
    keys = KeysSetup;
	
	
	%% mkdir
	session.saveDir = fullfile(directories.data, paradigmStr, [subject.name timeStamp]);
	if (~exist(session.saveDir, 'dir'))
		mkdir(session.saveDir);
	end
   
    %% 

end



