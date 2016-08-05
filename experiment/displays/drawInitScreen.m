function drawInitScreen(el, scr)

	[width, height] = Screen('WindowSize', scr.wPtr);
	size2 = round(el.calibrationtargetsize/100*width);
	rectt = CenterRectOnPoint([0 0 size2 size2], width/2, height/2);
    
    % Display info and dot on left screen
    Screen('SelectStereoDrawBuffer', scr.wPtr, 0);    
	Screen('FillRect', scr.wPtr, scr.calicolor, InsetRect(Screen('Rect', scr.wPtr), -1, -1));
	Screen('DrawText', scr.wPtr, 'CALIBRATION', scr.xc_l - 75, scr.yc_l - 50, scr.lwhite);
	Screen( 'FillOval', scr.wPtr, [el.foregroundcolor],  rectt );

    % Display info and dot on right screen 
    Screen('SelectStereoDrawBuffer', scr.wPtr, 1);    
	Screen('FillRect', scr.wPtr, scr.calicolor, InsetRect(Screen('Rect', scr.wPtr), -1, -1));
	Screen('DrawText', scr.wPtr, 'CALIBRATION', scr.xc_r - 75, scr.yc_r - 50, scr.rwhite);
    Screen( 'FillOval', scr.wPtr, [el.foregroundcolor],  rectt );
    
    % do the flip
	Screen('Flip', scr.wPtr, [], 1);
end