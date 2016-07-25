function trials = runCondition(mySession, myScr, condition, trial, s)

    mySession.timeStamp = datestr(clock, 'mm_dd_yy_HHMMSS');        
	% Open file for recording    
    if (mySession.recording) 
        eyelinkFile = [mySession.subj.name '_' mySession.eyelinkSaveBy num2str(s) '.edf'];
        Eyelink('Openfile', eyelinkFile);				
    end
    try 
        [trials.timing, trials.response] = runTrial(myScr, ...
            mySession.keys, condition, trial, mySession.recording);
            trials.isOK = 1;
    catch err
        display('runCondition Error!');
        display(err.message);
		display(err.stack(1).file);
		display(err.stack(1).line);
							
        %drop this trial
        if (mySession.recording)
            Eyelink('StopRecording');
            Eyelink('CloseFile');				
        end
        trials.isOK = 0;
    end
 
end
