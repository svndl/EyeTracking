function runSession
    
    %% Subject
    subject.name = 'AMN';
    subject.ipd = 6.5;    
    
    displayName = 'LG_OLED_TB';
    
    % Folder where you'll be saving the experiment data:
    % data/myStimset/subjName+date/
    
    myStimset = 'TowardsAwayAllCues';
    
    %% Setup session
    [mySession, myScr] = setupSession(displayName, subject, myStimset);
      
    %% are we recording?
    useEyelink = 0;
    
    %% Inint session
    if (useEyelink)
        if (~initSession(mySession, myScr))
            useEyelink = 0;
        end
    end
    
    %% Conditions
    conditions = feval(myStimset, myScr);
    mySession.recording = useEyelink;
    %% run experiment
    for s = 1:numel(conditions)    
        try
            trials = runCondition(mySession, myScr, conditions{s}, s);
            drawConditionEndScr(s, numel(conditions), myScr);
            saveCondition(mySession, conditions{s}.info, s, trials);            
        catch err
            display(['runSession Error condition #'  num2str(s)  ' caused by:']);
            display(err.message);
            display(err.stack(1).file);
            display(err.stack(1).line);
        end
    end
    ExitSession(useEyelink);
    % Save session info     
    saveSession(mySession, myScr);
    %copy files from the Eyelink
    if (mySession.recording)
        Eyelink('Initialize')      
        for nC = 1:numel(conditions)
            %transfer eyelink file and save
            fileName = [mySession.subj.name '_cnd' num2str(nC)];
            EyelinkTransferFile(mySession.saveDir, fileName);
        end
        Eyelink('Shutdown');
    end
end
