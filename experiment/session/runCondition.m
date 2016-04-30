function trials = runCondition(mySession, myScr, condition, s)

    mySession.timeStamp = datestr(clock, 'mm_dd_yy_HHMMSS');        
	trials = createTrials(condition.info);
	% Open file for recording    
    if (mySession.recording) 
        eyelinkFile = [mySession.subj.name '_cnd' num2str(s) '.edf'];
        Eyelink('Openfile', eyelinkFile);				
    end
    for t = 1:condition.info.nTrials
        try 
            [trials.timing(t), trials.response{t}] = runTrial(t, myScr, ...
                mySession.keys, condition, mySession.recording);
            trials.isOK(t) = 1;
        catch err
            display('runCondition Error!');
            display(err.message);
			display(err.stack(1).file);
			display(err.stack(1).line);
							
            %drop this trial
            if (mySession.recording)
                Eyelink('StopRecording');
            end
            trials.isOK(t) = 0;
        end
    end
    if (mySession.recording)    
        Eyelink('CloseFile');				
    end    
end
