function eyelink_run_calibration(dat, scr, el)
  
    eyelink_set_targets(scr)                     % setup target locations on screen
    
    % open file to record calibation data to
    Eyelink('Openfile', 'tmp.edf');
    
    %%%%% CALIBRATE EYETRACKER %%%%%
    %pressing v will start validation
    %press esc when finished
    eyelink_do_cali_steps(el, 'c');
    
    % transfer file
    Eyelink('CloseFile');
	try
		eyelink_transfer_file(dat, 'tmp.edf','_calibration_')
	catch
		disp('Could not transfer file, consider restarting ET session');
	end
end   
