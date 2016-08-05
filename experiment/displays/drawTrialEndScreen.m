function drawTrialEndScreen(scr)
	%
	% ending of a trial
	% clear screen
	Screen('FillRect', scr.wPtr, scr.background, InsetRect(Screen('Rect', scr.wPtr), -1, -1));
	Screen('Flip', scr.wPtr);
	WaitSecs(0.1);

    % left
    Screen('SelectStereoDrawBuffer', scr.wPtr, 0);    
	Screen('DrawText', scr.wPtr, 'Respond now', scr.xc_l - 25, scr.yc_l, scr.lwhite);
    
    % right
    Screen('SelectStereoDrawBuffer', scr.wPtr, 1);    
	Screen('DrawText', scr.wPtr, 'Respond now', scr.xc_r - 25, scr.yc_r, scr.rwhite);

    Screen('Flip', scr.wPtr);
end