function EyelinkRunCalibration(stm, scr, el)
  
    eyelink_set_targets(scr)                     % setup target locations on screen
    
    % open file to record calibation data to
    Eyelink('Openfile', 'tmp.edf');
    
    %%%%% CALIBRATE EYETRACKER %%%%%
    %pressing v will start validation
    %press esc when finished
    EyelinkCalibrationSteps(el, 'c');
    
    % transfer file
    Eyelink('CloseFile');
	try
		EyelinkTransferFile(stm, 'tmp.edf','_calibration_')
	catch
		disp('Could not transfer file, consider restarting ET session');
	end
end   
