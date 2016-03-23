function drawTrialEndScreen(scr)
	%
	% ending of a trial
	% clear screen
	Screen('FillRect', scr.wPtr, scr.background, InsetRect(Screen('Rect', scr.wPtr), -1, -1));
	Screen('Flip', scr.wPtr);
	WaitSecs(0.1);

	% ask for response
	%Screen('DrawText', w, 'Respond now', scr.x_center_pix_right - 25, scr.y_center_pix_right - 50, stm.REwhite);
	% planar 
	Screen('DrawText', scr.wPtr, 'Respond now', scr.x_center_pix_left - 25, scr.y_center_pix_left, scr.LEwhite);
	Screen('Flip', scr.wPtr);
end