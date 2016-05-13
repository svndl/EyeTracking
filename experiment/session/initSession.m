function [isOK] = initSession(session, scr)   
    try
        if (EyelinkInitialize)
            el = EyelinkSetup(scr);
            % save eyelink info ?
            
			drawInitScreen(el, scr);    
	
			display('Experimenter press Space when cameras are ready');
			
			%slight delay before calibration/validation
			KbWait;							
			WaitSecs(0.25);			
			EyelinkRunCalibration(session, scr, el);
            isOK = 1;
        end
	catch err
        isOK = 0;
		display(err.message);
		display(err.stack(1).file);
		display(err.stack(1).line);
    end
end