function drawBlockEndScr(blk, nBlk, scr)
	%% display how much time left
    
    Screen('SelectStereoDrawBuffer', scr.wPtr, 0);    
	Screen('DrawText', scr.wPtr, ['Done block' num2str(blk) ' of ' num2str(nBlk) ' '], ...
		scr.xc_l - 25, scr.yc_l, scr.lwhite);
    
    Screen('SelectStereoDrawBuffer', scr.wPtr, 1);    
	Screen('DrawText', scr.wPtr, ['Done block' num2str(blk) ' of ' num2str(nBlk) ' '], ...
		scr.xc_r - 25, scr.yc_r, scr.rwhite);

    Screen('Flip', scr.wPtr);
	WaitSecs(2);
end
