function drawConditionEndScr(cnd, ncnd, scr)
	%% display how much time left
	Screen('DrawText', scr.wPtr, ['Done block' num2str(cnd) ' of ' num2str(ncnd) ' '], ...
		scr.xc_l - 25, scr.yc_l, scr.lwhite);
	Screen('Flip', scr.wPtr);
	WaitSecs(2);
end
