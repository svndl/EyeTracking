function runSession
    
    %% Subject
    subject.name = 'AY';
    subject.ipd = 6.5;    
    
    displayName = 'LG_OLED_TB';     
    paradigmStr = 'TowardsAwayAllCues';
    
    %% Setup session
    [mySession, myScr] = setupSession(displayName, subject, paradigmStr);
      
    %% are we recording?
    useEyelink = 1;
    
    %% Inint session
    if (useEyelink)
        if (~initSession(mySession, myScr))
            useEyelink = 0;
        end
    end
    
    %% Conditions
    conditions = ta_TestSet(myScr);
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
    ExitSession(useEyelink);
end
