function trials = runBlock(mySession, BlkNum)
% function will run a given number of randomly selected trials
% input args
% output args
	% Open file for recording    
    if (mySession.recording) 
        eyelinkFile = [mySession.subj.name '_' mySession.runSequence num2str(BlkNum) '.edf'];
        Eyelink('Openfile', eyelinkFile);				
    end
    currBlk = mySession.stimSequence(:, BlkNum);
    for t = 1:numel(currBlk)
        display(['Running block ' num2str(BlkNum) ' trial ' num2str(t)]);
        currCndNum = currBlk(t);
        condition = mySession.conditions{currCndNum};
        try 
        [tt{t}, rs{t}] = runTrial(mySession, condition);
        catch err
            display(['Error running condition ' num2str(currCndNum)]);
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
    trials.timing = tt;
    trials.response = rs;
end