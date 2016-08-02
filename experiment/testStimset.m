function testStimset
        
    displayName = 'LG_OLED_TB';
    
    % Folder where you'll be saving the experiment data:
    % data/myStimset/subjName+date/
    
    myStimset = 'TowardsAwayAllCues';
    
    %% Setup session
    displayParams = eval(displayName);	
    myScr = setupVideoMode(displayParams);    
    
    conditions = feval(myStimset, myScr);
       
    %% run experiment
    for c = 1:numel(conditions)
        condition = conditions{c};
        try
            % display one
            
            msgTrialDescription = [condition.info.name ':' ...
                condition.info.dynamics{:} ':'...
                condition.info.direction{:}];    
	
            display(msgTrialDescription);
    
            %% pre-generate stimulus frames
            [dotFrames, dotColor, dotSize] = feval(condition.fhandle, condition.fparams{:});
            noniusLines = getNoniusLines(condition.info.nonius, myScr);
    
            %% pre-generate stimulus frames
    
            %% draw fixation
            drawFixation_Stereo(myScr);
    
            dotUpdate = round(myScr.frameRate/condition.info.dotUpdateHz);
            drawDots(dotFrames, dotColor, dotSize, myScr,...
                dotUpdate, noniusLines, msgTrialDescription);
    
            % clear screen at end
            drawTrialEndScreen(myScr);
        catch err
            display(['runSession Error block #'  num2str(c)  ' caused by:']);
            display(err.message);            
            for e = 1: numel(err.stack)
                display(err.stack(e).file);
                display(err.stack(e).line);
            end
            sca;                   
            ListenChar(0);
            commandwindow;
        end
    end
	sca;                   
	ListenChar(0);
	commandwindow;    
end
