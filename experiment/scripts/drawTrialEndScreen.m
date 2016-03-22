function drawTrialEndScreen(w, scr)
	%
	% ending of a trial
	% clear screen
	Screen('FillRect', w, [scr.blevel], InsetRect(Screen('Rect', w), -1, -1));
	Screen('Flip', w);
	WaitSecs(0.1);

	% ask for response
	%Screen('DrawText', w, 'Respond now', scr.x_center_pix_right - 25, scr.y_center_pix_right - 50, stm.REwhite);
	% planar 
	Screen('DrawText', w, 'Respond now', scr.x_center_pix_left - 25, scr.y_center_pix_left, scr.LEwhite);
	Screen('Flip', w);
end