function [scr, w, winRect] = setupDisplay(disp)
%
%
    scr = disp;
    scr.screenNumber = max(Screen('Screens'));      % Use max screen number
    PsychImaging('PrepareConfiguration');       % Prepare pipeline for configuration.

    if scr.skipSync
        Screen('Preference', 'SkipSyncTests', 1);
    else
        Screen('Preference', 'SkipSyncTests', 0);
    end


    [w, winRect] = PsychImaging('OpenWindow', scr.screenNumber, ...
        0, [], [], [], [], 4);      % Open PTB graphics window
    Screen(w, 'BlendFunction', GL_ONE, GL_ONE);                      % Enable alpha blending - these are the settings that are needed for Planar

    %fill screen
    Screen('FillRect', w, [0 0 0], InsetRect(Screen('Rect', w), -1, -1));
    Screen('Flip', w);
    
    
    %update framerate
    scr.frameRate   = Screen('NominalFrameRate',w);

    if scr.frameRate < 1
        scr.frameRate = 60; % ### Workaround by Holly G. Jan. 7 2016, so that iMac display (which returns 0 for the framerate) will work
        fprintf('\nScreen frame rate has been set to 60 Hz\n')
    end

    % PTB can't seem to get the frame rate of this display
    if strcmp(scr.name, 'CinemaDisplayRB');
        scr.frameRate = 60;
        warning('Note: CinemaDisplay true frame rate is 59.95 Hz but is being set as 60.');
    end

    %get the actual display resolution
    
    scr.width_pix   = RectWidth(Screen('Rect', scr.screenNumber));
    scr.height_pix  = RectHeight(Screen('Rect', scr.screenNumber));

    % Disable key output to Matlab window:
    ListenChar(2);

    % if using planar, must be in native resolution for accurate eyetracking
    if strcmp(scr.name, 'planar')
        res = Screen('Resolution', scr.screenNumber);
        if res.width ~= 1600 || res.height ~= 1200 || res.pixelSize ~= 32 || res.hz ~= 60
            fprintf('Planar not in native resolution');
        end
    end
    
    if scr.topbottom == 1
        scr.Yscale = 0.5;
    else
        scr.Yscale = 1;
    end
    
    scr.cm2pix              = scr.width_pix/scr.width_cm;                           % conversion for cm to pixels
    scr.pix2arcmin          = 2*60*atand(0.5/(scr.viewDistCm*scr.cm2pix));          % conversion from pixels to arcminutes
    display(['1 pixel = ' num2str(scr.pix2arcmin,2) ' arcmin']);

    scr.x_center_pix        = scr.width_pix/2;                                      % l/r screen center
    scr.y_center_pix        = scr.height_pix/2 - (scr.stimCenterYCm*scr.cm2pix);    % u/d screen center

    scr.y_center_pix_left   = scr.y_center_pix;                                     % left eye right eye centers...
    scr.y_center_pix_right  = scr.y_center_pix;

    scr.x_center_pix_left   = scr.x_center_pix - (scr.prismShiftCm*scr.cm2pix);
    scr.x_center_pix_right  = scr.x_center_pix + (scr.prismShiftCm*scr.cm2pix);

    scr.calicolor = [0 0 0];

    scr.caliRadiusDeg  = 8;			% this is the region of the screen that will be covered by calibration dots
    scr.caliRadiusPixX = ceil(scr.caliRadiusDeg*60*(1/scr.pix2arcmin)); % converted to pixels
    scr.caliRadiusPixY = scr.caliRadiusPixX/2; % y radius is half the size
        
end