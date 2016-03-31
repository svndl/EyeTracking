function scr = setupVideoMode_new(inputScr)
% open and set up PTB screen window
% get running videosystem parameters (resolution, framerate)
% update screen info structure 

    colormode = setupColor(inputScr);
    scrPTB = setupPTB(colormode);
    scr = setupFixation(scrPTB);    
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
	[wPtr, wRect] = PsychImaging('OpenWindow', outScr.screenNumber, ...
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
    % copy links to scree
    outScr.wPtr = wPtr;
    outScr.wRect = wRect;
end

function outScr = setupFixation(inScr)  
    outScr = inScr;
    outScr.cm2pix    = outScr.width_pix/outScr.width_cm;                           
	outScr.pix2arcmin = 2*60*atand(0.5/(outScr.viewDistCm*outScr.cm2pix));          

	display(['1 pixel = ' num2str(outScr.pix2arcmin,2) ' arcmin']);

	outScr.xc = outScr.width_pix/2;                                      
	outScr.yc = outScr.height_pix/2 - (outScr.stimCenterYCm*outScr.cm2pix);    

	outScr.yc_l = outScr.yc;                                     
	outScr.yc_r = outScr.yc;
    
    
    prismShiftPix = outScr.prismShiftCm*outScr.cm2pix;
	
    outScr.xc_l = outScr.xc - prismShiftPix;
	outScr.xc_r = outScr.xc + prismShiftPix;

    outScr.calicolor = [0 0 0];                      

	caliRadiusDeg	= 8;
	outScr.clbRadiusX = ceil(caliRadiusDeg*60*(1/outScr.pix2arcmin));
	outScr.clbRadiusY = outScr.clbRadiusX/2;
	
	outScr.Yscale = 1;
	
	if outScr.topbottom == 1
		outScr.Yscale = 0.5;
	end
	
	fixationRadiusDeg = 1;
	outScr.fxRadius = (60*fixationRadiusDeg)/outScr.pix2arcmin;
	outScr.fRadiusSq = outScr.fxRadius^2;

	fixationDotRadiusDeg = 0.125;
	outScr.fxDotRadius = (60*fixationDotRadiusDeg)/outScr.pix2arcmin;

	outScr.fxRadiusY = outScr.fxRadius*outScr.Yscale;
	outScr.fxRadiusX = outScr.fxRadius;
end
function outScr = setupColor(inputScr)
    
    outScr = inputScr;
    outScr.background = [inputScr.gray inputScr.gray inputScr.gray];
	
    switch inputScr.name
    
		case {'planar','laptopRB','LG3DRB','CinemaDisplayRB'}
            % blue-left, red-right             
			outScr.lwhite = [inputScr.white inputScr.gray inputScr.gray];
			outScr.lblack = [inputScr.black inputScr.black inputScr.gray];
            
            outScr.rwhite = [inputScr.gray inputScr.gray inputScr.white];
			outScr.rblack = [inputScr.gray inputScr.black inputScr.black];
        otherwise                                                   
            % use white/black
			outScr.lwhite = [inputScr.white inputScr.white inputScr.white];
			outScr.lblack = [inputScr.black inputScr.black inputScr.black];
        
			outScr.rwhite = [inputScr.white inputScr.white inputScr.white];
			outScr.rblack = [inputScr.black inputScr.black inputScr.black]; 
    end
end
