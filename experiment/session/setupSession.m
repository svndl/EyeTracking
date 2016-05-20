function [session, scr] = setupSession(display, subj, stimsetStr)
    displayParams = eval(display);
    	
    directories = setPath;             
    timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');
	    	
    %% mkdir
    session.saveDir = fullfile(directories.data, stimsetStr, [subj.name timeStamp]);
    if(~exist(session.saveDir, 'dir'))
		mkdir(session.saveDir);
    end
    
    %% copy info to session
    session.subj = subj;
    session.keys = setupKeyboard;
    scr = setupVideoMode(displayParams);
end
