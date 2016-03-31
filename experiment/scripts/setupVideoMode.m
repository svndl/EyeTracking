function [scr, winRect] = setupVideoMode(inputScr)
% open and set up PTB screen window
% get running videosystem parameters (resolution, framerate)
% update screen info structure 

    colormode = setupColor(inputScr.name, inputScr.colormode);
	scrPTB = setupPTB(inputScr);
    fixation = setupFixation(scrPTB);
    
    scr = catstruct(fixation, colormode);
    
    %% store pointers
    scr.wPtr = wPtr;
    scr.winRect = winRect;	
end
function outScr = setupPTB(inScr)
    outScr = inScr;

	outScr.screenNumber = max(Screen('Screens'));      % Use max screen number
	PsychImaging('PrepareConfiguration');       % Prepare pipeline for configuration.

% 	if scr.skipSync
% 		Screen('Preference', 'SkipSyncTests', 1);
% 	else
% 		Screen('Preference', 'SkipSyncTests', 0);
%     end

    Screen('Preference', 'SkipSyncTests', 2);
    
    % Open PTB graphics window, should be upscaled by a factor of 4 for antialiasing
    % Enable alpha blending - these are the settings that are needed for Planar
	[wPtr, winRect] = PsychImaging('OpenWindow', outScr.screenNumber, ...
                                        0, [], [], [], [], 4);      
	Screen(wPtr,'BlendFunction', GL_ONE, GL_ONE_MINUS_SRC_ALPHA); 
    Screen('Preference', 'VisualDebugLevel', 1)  

	%fill screen
    
	Screen('FillRect', wPtr, outScr.background, InsetRect(Screen('Rect', wPtr), -1, -1));
	Screen('Flip', wPtr);

	outScr.frameRate = Screen('NominalFrameRate', wPtr);

	% PTB can't seem to get the frame rate of this display\
    if strcmp(outScr.name,'CinemaDisplay') || strcmp(outScr.name,'planar')
		outScr.frameRate = 60;
		warning('Set CinemaDisplay/Planar true frame rate');
    end 
    
	outScr.width_pix   = RectWidth(Screen('Rect', outScr.screenNumber));
	outScr.height_pix  = RectHeight(Screen('Rect', outScr.screenNumber));

	% Disable key output to Matlab window:
	ListenChar(2);

	% if using planar, must be in native resolution for accurate eyetracking
	if strcmp(outScr.name,'planar')
		res = Screen('Resolution', outScr.screenNumber);
    
		if res.width ~= 1600 || res.height ~= 1200 || res.pixelSize ~= 32 || res.hz ~= 60
			warning('Planar not in native resolution');
		end
    end
end

function outScr = setupFixation(inScr)
    
    outScr = inScr;
    outScr.cm2pix              = outScr.width_pix/outScr.width_cm;                           
	outScr.pix2arcmin          = 2*60*atand(0.5/(outScr.viewDistCm*outScr.cm2pix));          

	display(['1 pixel = ' num2str(outScr.pix2arcmin,2) ' arcmin']);

	outScr.x_center_pix        = outScr.width_pix/2;                                      
	outScr.y_center_pix        = outScr.height_pix/2 - (outScr.stimCenterYCm*outScr.cm2pix);    

	outScr.y_center_pix_left   = outScr.y_center_pix;                                     
	outScr.y_center_pix_right  = outScr.y_center_pix;

	outScr.x_center_pix_left   = outScr.x_center_pix - (outScr.prismShiftCm*outScr.cm2pix);
	outScr.x_center_pix_right  = outScr.x_center_pix + (outScr.prismShiftCm*outScr.cm2pix);

    outScr.calicolor = [0 0 0];                      

	outScr.caliRadiusDeg		= 8;
	outScr.caliRadiusPixX      = ceil(outScr.caliRadiusDeg*60*(1/outScr.pix2arcmin));
	outScr.caliRadiusPixY      = outScr.caliRadiusPixX/2;
	
	outScr.Yscale = 1;
	
	if outScr.topbottom == 1
		outScr.Yscale = 0.5;
	end
	
	outScr.fixationRadiusDeg = 1;
	outScr.fixationRadiusPix = (60*outScr.fixationRadiusDeg)/outScr.pix2arcmin;
	outScr.fixationRadiusSqPix = outScr.fixationRadiusPix^2;

	outScr.fixationDotRadiusDeg = 0.125;
	outScr.fixationDotRadiusPix = (60*outScr.fixationDotRadiusDeg)/outScr.pix2arcmin;

	outScr.fixationRadiusYPix = outScr.fixationRadiusPix*outScr.Yscale;
	outScr.fixationRadiusXPix = outScr.fixationRadiusPix;
end
function outScr = setupColor(displayName, colormode)

    switch colormode
        
        case 'saltpepper'
            outScr.white = 255;       
            outScr.gray = 127;          
            outScr.black = 0;            
        case 'blackwhite'
            outScr.white = 255;       
            outScr.gray = 0;          
            outScr.black = 0;
    end
    
    
    outScr.background = [outScr.gray outScr.gray outScr.gray];
	switch displayName
    
		case {'planar','laptopRB','LG3DRB','CinemaDisplayRB'}
            % blue-left, red-right             
			outScr.left.white = [outScr.white outScr.gray outScr.gray];
			outScr.left.black = [outScr.black outScr.gray outScr.gray];
            
            outScr.right.white = [outScr.gray outScr.gray outScr.white];
			outScr.right.black = [outScr.gray outScr.black outScr.black];
        otherwise                                                   
            % use white/black
			outScr.left.white = [outScr.white outScr.white outScr.white];
			outScr.left.black = [outScr.black outScr.black outScr.black];
        
			outScr.right.white = [outScr.white outScr.white outScr.white];
			outScr.right.black = [outScr.black outScr.black outScr.black]; 
    end
    
    %salt'n'pepper
end
