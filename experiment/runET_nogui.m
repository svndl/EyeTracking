function runET_nogui
    % example: run_experiment(exp_name)
    
    etpath = setPath_ET;
    
    % GET EXPERIMENT VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    dspl        = getDisplays(etpath.displays);
    conds       = getConditions;
    dyn         = getDynamics;
    ipdmat      = getIpds;
    dirs        = {'away', 'towards', 'left', 'right'};
    exp         = getExperiments(etpath.experiments);
    
    myDisplay = 'laptop';
    myExperiment = 'test';
    mySubj = 'XX';
    % load in experiment settings

    myData.exp_name = myExperiment;
    myData.display  = myDisplay;
    myDisplay       = dspl.data{ismember(dspl.names, myData.display)};
    myData          = exp.data{ismember(exp.names, myData.exp_name)};        
    myData.subj     = mySubj;
    

    make_data_dirs(etpath.results, myExperiment, mySubj);              % make directories to store session data
    myData.timeNow = datestr(clock, 'mm_dd_yy_HHMMSS'); % get start time for file names

    
	% SET UP SCREEN, STIMULUS, WINDOW, TRACKER, KEYS %%%%%%%%%%%%%%%%%%%%%%%%%%

    [scr, wPtr, ~]       = setupDisplay(myDisplay);         % PTB window
     myKeys              = setupKb();           % key responses
    [myData, scr, myStm] = setupExperiment(myData, scr);   % stimulus properties
    
    %setup eyelink
    try
        el = eyelink_setup(myData, wPtr, scr);  % give Eyelink details about graphics, perform some initializations
        eyelink_init_connection(myData.recording);         % if recording, initialize the connection to Eyelink
    catch
    end

    % DRAW INTRO SCREEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     try
%         screen_draw_intro(el, scr, wPtr)     % static screen
%     catch
%     end
%     display('Experimenter press Space when cameras are ready');	% experimentor starts C/V by hitting space bar
%     KbWait;							
%     WaitSecs(0.25);			% slight delay before starting
% 

    % CALIBRATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Working properly relies on having the correct settings in the file
    % LASTRUN.INI 
    % if this breaks, you may need to open ET computer in Windows, copy the
    % old LASTRUN_XXX.INI file into the main last run file and restart the
    % tracker
    
    try
        eyelink_run_calibration(myData,scr, el)
    catch
    end

    % RUN TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    myData.recording = 0;
    if myData.recording
        Eyelink('Openfile', 'tmp.edf'); % open file to record data to
    end   

    for t = 1:length(myData.trials.trialnum)                   % for each trial
    
        % trial info
        trial           = myData.trials.trialnum(t);           % which stimulus index to take
        condition       = myData.trials.condition{trial};      % condition
        dynamics        = myData.trials.dynamics{trial};       % dynamics
        direction       = myData.trials.direction{trial};      % towards, away, left, right
        delay           = myData.trials.delayUpdates(trial);   % number of dot updates to delay before prelude
        
        
        display([condition ' ' dynamics ' ... direction = ' direction]);
    
    
        % pre-generate stimulus frames for this trial (and for the random delay period)
        [dotsLE,dotsRE]   = stimulus_pregenerate_trial(scr, myStm, condition, dynamics, direction, delay);
    
    
        % initialize trial
        stimulus_draw_fixation(wPtr, scr ,myStm);                  % static fixation pattern before stimulus
        KbCheck()
        keys_wait(myKeys, myData)                                  % subject starts trials
        if myData.recording; Eyelink('StartRecording');  end       % start recording eye position

        % show trial (with random delay first)
        myData = stimulus_draw_trial(wPtr,trial,dotsLE,dotsRE,myData,myStm,scr,condition,dynamics,direction,delay);
    
    
        % clear screen at end
        stimulus_draw_end_screen(wPtr,myStm,scr);
    
    
        % get subject responses
        while myKeys.isDown == 0
            [myData, myKeys] = keys_get_response(myKeys, myData, myStm, trial, direction);
        end
        myKeys.isDown = 0;
    
    end

    % aggregate and save data structures
    myData.keys            = myKeys;
    myData.display_info    = scr;
    myData.stim_info       = myStm;
    store_results(myData);

    % exit
    
    %Screen('DrawText', w, 'Done', scr.x_center_pix_right - 25, scr.y_center_pix_right - 50, dat.stim_info.REwhite);
    Screen('DrawText', wPtr, 'Done', scr.x_center_pix_left - 25, scr.y_center_pix_left - 50, myData.stim_info.LEwhite);
    Screen('Flip', wPtr);
    WaitSecs(2);
    cleanup(0, myData);
end