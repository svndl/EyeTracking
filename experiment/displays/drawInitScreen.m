function drawInitScreen(el, scr)

	[width, height] = Screen('WindowSize', scr.wPtr);
	Screen('FillRect', scr.wPtr, scr.calicolor, InsetRect(Screen('Rect', scr.wPtr), -1, -1));
	Screen('DrawText', scr.wPtr, 'CALIBRATION', scr.xc_l - 75, scr.yc_l - 50, scr.lwhite);

	%Screen('DrawText', window, 'CALIBRATION', width/2 - 25, height/2 - 50, [scr.calicolor(1) 255 255]);
	size2 = round(el.calibrationtargetsize/100*width);
	rectt = CenterRectOnPoint([0 0 size2 size2], width/2, height/2);
	Screen( 'FillOval', scr.wPtr, [el.foregroundcolor],  rectt );
	Screen('Flip', scr.wPtr, [], 1);
end