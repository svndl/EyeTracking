function session = setupSession(display, subj, stimsetStr, varargin)
    
    %% setup directories	
    directories = setPath;             
    timeStamp = datestr(clock,'mm_dd_yy_HHMMSS');
	    	
    % mkdir
    session.saveDir = fullfile(directories.data, stimsetStr, [subj.name timeStamp]);
    if(~exist(session.saveDir, 'dir'))
		mkdir(session.saveDir);
    end
    
    %% setup devices
    [myKeys, mySound, myScr, myEl] = setupDevices(display);
    
    %% setup stimulus
    [myConditions, myTriaslCount, myStimSequence, runSequence] = setupStimulus(myScr, stimsetStr, varargin);
    
    session.keys = myKeys;
    session.sound = mySound;
    session.scr = myScr;
    session.el = myEl;
    session.conditions = myConditions;
    session.stimSequence = myStimSequence;
    session.triaslCount = myTriaslCount;
    session.runSequence = runSequence;
    session.nBlocks = size(myStimSequence, 2);
end
