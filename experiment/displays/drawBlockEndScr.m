function drawBlockEndScr(blk, nBlk, scr)
	%% display how much time left
	Screen('DrawText', scr.wPtr, ['Done block' num2str(blk) ' of ' num2str(nBlk) ' '], ...
		scr.xc_l - 25, scr.yc_l, scr.lwhite);
	Screen('Flip', scr.wPtr);
	WaitSecs(2);
end
