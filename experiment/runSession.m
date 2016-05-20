function runSession
    
    %% Subject
    subject.name = 'AY';
    subject.ipd = 6.5;    
    
    displayName = 'LG_OLED_TB';
    
    % Folder where you'll be saving the experiment data:
    % data/myStimset/subjName+date/
    
    myStimset = 'TowardsAwayAllCues';
    
    %% Setup session
    [mySession, myScr] = setupSession(displayName, subject, myStimset);
      
    %% are we recording?
    useEyelink = 1;
    
    %% Inint session
    if (useEyelink)
        if (~initSession(mySession, myScr))
            useEyelink = 0;
        end
    end
    
    %% Conditions
    conditions = myStimset(myScr);
    mySession.recording = useEyelink;
    %% run experiment
    for s = 1:numel(conditions)    
        try
            trials = runCondition(mySession, myScr, conditions{s}, s);
            drawConditionEndScr(s, numel(conditions), myScr);
            saveCondition(mySession, conditions{s}.info, myScr, s, trials);            
        catch err
            display(['runSession Error condition #'  num2str(s)  ' caused by:']);
            display(err.message);
            display(err.stack(1).file);
            display(err.stack(1).line);
        end
    end
    
    if (mySession.recording)
        for nC = 1:numel(conditions)
            %transfer eyelink file and save
            fileName = [mySession.subj.name '_cnd' num2str(nC)];
            EyelinkTransferFile(mySession.saveDir, fileName);
        end
    end
    % Save session info  
    saveSession(mySession, myScr);
    ExitSession(useEyelink);
end
