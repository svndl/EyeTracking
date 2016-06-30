function getEyelinkDataProj


    proj = uigetdir();
    
    sessions = getSessionsList(proj);
    
    trialDuration = 1;
    hasSpeed = 0;
    if(strcmp(filename(end-3:end), 'edf'))
        hasSpeed = 1;
        eyelinkRec = processEyelinkFile_edfmex(filename);
        
    else
        eyelinkRec = processEyelinkFile(filename);
    end
    
    if (hasSpeed)
        [~, vel_true] =  processTrialData(eyelinkRec(:, [1, 6:end]), sessionInfo.subj.ipd, trialDuration);               
    end

    [timecourse, pos, vel_calc] =  ...
        processTrialData(eyelinkRec, sessionInfo.subj.ipd, trialDuration);
    subplot(2, 1);
    plot(timecourse, [pos.L; pos.R]);
    subplot(2, 2);
    plot(timecourse, [vel_true.L; vel_true.R vel_calc.L vel_calc.R]);    
end