function [scr, w, winRect] = setupVideoMode(inputScr)
% open and set up PTB screen window
% get running videosystem parameters (resolution, framerate)
% update screen info structure 

	scr = inputScr;
	
	scr.screenNumber = max(Screen('Screens'));      % Use max screen number
	PsychImaging('PrepareConfiguration');       % Prepare pipeline for configuration.

	if scr.skipSync
		Screen('Preference', 'SkipSyncTests', 1);
	else
		Screen('Preference', 'SkipSyncTests', 0);
	end


	[w, winRect] = PsychImaging('OpenWindow', scr.screenNumber, ...
                                        0, [], [], [], [], 4);      % Open PTB graphics window, should be upscaled by a factor of 4 for antialiasing
	Screen(w,'BlendFunction',GL_ONE, GL_ONE);                      % Enable alpha blending - these are the settings that are needed for Planar

	%fill screen
	Screen('FillRect', w, [0 0 0], InsetRect(Screen('Rect', w), -1, -1));
	Screen('Flip', w);

	scr.frameRate   = Screen('NominalFrameRate',w);

	% PTB can't seem to get the frame rate of this display
	if strcmp(scr.name,'CinemaDisplay') || strcmp(scr.name,'planar')
		scr.frameRate = 60;
		warning('Set CinemaDisplay/Planar true frame rate');
	end

	scr.width_pix   = RectWidth(Screen('Rect', scr.screenNumber));
	scr.height_pix  = RectHeight(Screen('Rect', scr.screenNumber));

	% Disable key output to Matlab window:
	ListenChar(2);

	% if using planar, must be in native resolution for accurate eyetracking
	if strcmp(scr.name,'planar')
		res=Screen('Resolution', scr.screenNumber);
    
		if res.width ~= 1600 || res.height ~= 1200 || res.pixelSize ~= 32 || res.hz ~= 60
			warning('Planar not in native resolution');
		end
	end

	
	scr.cm2pix              = scr.width_pix/scr.width_cm;                           
	scr.pix2arcmin          = 2*60*atand(0.5/(scr.viewDistCm*scr.cm2pix));          

	display(['1 pixel = ' num2str(scr.pix2arcmin,2) ' arcmin']);

	scr.x_center_pix        = scr.width_pix/2;                                      
	scr.y_center_pix        = scr.height_pix/2 - (scr.stimCenterYCm*scr.cm2pix);    

	scr.y_center_pix_left   = scr.y_center_pix;                                     
	scr.y_center_pix_right  = scr.y_center_pix;

	scr.x_center_pix_left   = scr.x_center_pix - (scr.prismShiftCm*scr.cm2pix);
	scr.x_center_pix_right  = scr.x_center_pix + (scr.prismShiftCm*scr.cm2pix);

    scr.calicolor = [0 0 0];                      

	scr.caliRadiusDeg		= 8;
	scr.caliRadiusPixX      = ceil(scr.caliRadiusDeg*60*(1/scr.pix2arcmin));
	scr.caliRadiusPixY      = scr.caliRadiusPixX/2;
	
	scr.Yscale = 1;
	
	if scr.topbottom == 1
		scr.Yscale = 0.5;
	end
	
	scr.fixationRadiusDeg = 1;
	scr.fixationRadiusPix = (60*scr.fixationRadiusDeg)/scr.pix2arcmin;
	scr.fixationRadiusSqPix = scr.fixationRadiusPix^2;

	scr.fixationDotRadiusDeg = 0.125;
	scr.fixationDotRadiusPix = (60*scr.fixationDotRadiusDeg)/scr.pix2arcmin;

	scr.fixationRadiusYPix = scr.fixationRadiusPix*scr.Yscale;
	scr.fixationRadiusXPix = scr.fixationRadiusPix;
	
end