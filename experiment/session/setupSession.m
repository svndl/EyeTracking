function [session, scr] = setupSession(display, subj)
    displayParams = eval(display);
    	
	directories = setPath;             
	timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');
	paradigmStr = 'TestingNewCode';
	
	%% Screen, Keyboard
    displayParams.white = 180;
    displayParams.gray = 127;
    displayParams.black = 0;
    	
	%% mkdir
	session.saveDir = fullfile(directories.data, paradigmStr, [subj.name timeStamp]);
    if(~exist(session.saveDir, 'dir'))
		mkdir(session.saveDir);
    end
    
    %% copy info to session
    session.subj = subj;
    session.keys = setupKeyboard;
    scr = setupVideoMode(displayParams);
end