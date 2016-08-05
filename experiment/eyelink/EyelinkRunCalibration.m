function EyelinkRunCalibration(session)
  
    EyelinkSetTargets(session.scr)                     % setup target locations on screen
    
    % open file to record calibation data to
    fileCalibration = [session.subj.name '_cali'];
    Eyelink('Openfile', [fileCalibration '.edf']);
    
    % Calibrate/Validate EYETRACKER %
    %pressing v will start validation
    %press esc when finished
    
    EyelinkCalibrationSteps(session.el, 'c');
    %EyelinkCalibrationSteps(session.el, 'v');

    % transfer file
    Eyelink('CloseFile');
	try
        Eyelink()
		EyelinkTransferFile(session.saveDir, fileCalibration);
	catch
		disp('Could not transfer file, consider restarting ET session');
	end
end   
