function runSession
    
    %% Subject
    subject.name = 'AMN';
    subject.ipd = 6.5;    
    
    displayName = 'LG_OLED_TB';
    
    % Folder where you'll be saving the experiment data:
    % data/myStimset/subjName+date/
    
    myStimset = 'TowardsAwayAllCues';
    
    %% Setup session
    runType = 'blk';
    mySession = setupSession(displayName, subject, myStimset, runType);
      
    %% are we recording?
    useEyelink = 0;
    
    %% Inint session
    if (useEyelink)
        if (~initSession(mySession))
            useEyelink = 0;
        end
        mySession.eyelink_ts = EyelinkTimingFlags('message'); 
    end
    
    mySession.recording = useEyelink;
    % Save session info     
    saveSession(mySession);

    %% run experiment
    for b = 1:mySession.nBlocks
        try
            trials = runBlock(mySession, b);
            saveBlock(mySession, trials, b);
        catch err
            display(['runSession Error block #'  num2str(b)  ' caused by:']);
            display(err.message);            
            for e = 1: numel(err.stack)
                display(err.stack(e).file);
                display(err.stack(e).line);
            end
        end
    end
    ExitSession(useEyelink);
    
    %copy files from the Eyelink
    if (mySession.recording)
        Eyelink('Initialize')      
        for nb = 1:1:mySession.nBlocks
            %transfer eyelink file and save
            fileName = [mySession.subj.name '_' mySession.runSequence num2str(nb)];
            EyelinkTransferFile(mySession.saveDir, fileName);
        end
        Eyelink('Shutdown');
    end
    if (useEyelink)
        prompt = 'Do you want to process this session? y/n [y]: ';
        str = input(prompt, 's');
        if (strcmp(str, 'y') || strcmp(str, 'Y'))
            gui_loadSession(mySession.saveDir);
        end
    end;
end
