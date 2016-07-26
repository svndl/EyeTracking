function runSession
    
    %% Subject
    subject.name = 'AMN';
    subject.ipd = 6.5;    
    
    displayName = 'LG_OLED_TB';
    
    % Folder where you'll be saving the experiment data:
    % data/myStimset/subjName+date/
    
    myStimset = 'SDRampsP';
    
    %% Setup session
    [mySession, myScr] = setupSession(displayName, subject, myStimset);
      
    %% are we recording?
    useEyelink = 0;
    
    %% Inint session
    if (useEyelink)
        if (~initSession(mySession, myScr))
            useEyelink = 0;
        end
        mySession.eyelink_ts= EyelinkTimingFlags('message'); 
    end
    
    %% Conditions
    conditions = feval(myStimset, myScr);
    [~, cndSeq] = generateTrials(conditions);

    %useRand = 1;
    nCnd = numel(conditions);
    savedInfo = cell(nCnd, 1);
    trialCounter = ones(nCnd, 1);
    nTrials = numel(cndSeq);
    randCndSeq = randperm(nTrials);
    mySession.recording = useEyelink;
    %% run experiment
    for t = 1:nTrials
        currCndNum = cndSeq(randCndSeq(t));
        try
            tr = runCondition(mySession, myScr, conditions{currCndNum}, trialCounter(currCndNum), currCndNum);
            savedInfo{currCndNum}.trials(trialCounter(currCndNum)) = tr;
            savedInfo{currCndNum}.info = conditions{currCndNum}.info;
            trialCounter(currCndNum) = trialCounter(currCndNum) + 1;            
        catch err
            display(['runSession Error Condition #'  num2str(currCndNum)  ' caused by:']);
            display(err.message);
            display(err.stack(1).file);
            display(err.stack(1).line);
        end
    end
    ExitSession(useEyelink);
    
    % save condition info (trials, info)
    for nC = 1:numel(conditions)
        saveCondition(mySession, savedInfo{nC}.info, nC, savedInfo{currCndNum}.trials);
    end    
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
    if (useEyelink)
        prompt = 'Do you want to process this session? y/n [y]: ';
        str = input(prompt, 's');
        if (strcmp(str, 'y') || strcmp(str, 'Y'))
            gui_loadSession(mySession.saveDir);
        end
    end;
end
