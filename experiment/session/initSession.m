function [isOK] = initSession(session)   
    try
        if (EyelinkInitialize)
            EyelinkUpdateDefaults(session.el);
            % save eyelink info ?
            
			drawInitScreen(session.el, session.scr);    
	
			display('Experimenter press Space when cameras are ready');
			
			%slight delay before calibration/validation
			KbWait;							
			WaitSecs(0.25);			
			EyelinkRunCalibration(session);
            isOK = 1;
        end
	catch err
        isOK = 0;
		display(err.message);
		display(err.stack(1).file);
		display(err.stack(1).line);
    end
end