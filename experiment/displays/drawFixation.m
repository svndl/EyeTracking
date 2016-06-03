function drawFixation(scr, flipIt, varargin)
%
% draws binocular fixation nonius to the screen, if flipIt is 1, then draw
% full nonius and flip, if flipIt is 0, draw only verticals and wait to
% flip until the stimulus is drawn too    
    %support for 3D
    % length of diagonal lines
	fxRadiusX2 = sqrt(((scr.fxRadiusX).^2)/2);
	fxRadiusY2 = sqrt(((scr.fxRadiusY).^2)/2);
 	
    % line width in pixels
	line_width  = 2;    
    
	%% nonius lines
	% vertical
	if flipIt
		% make verticals the same as all other lines
		vert_R = scr.fxRadiusY;
		vert_W  = line_width;
    else
		% make verticals the same as all other lines
		vert_R = scr.fxRadiusY*2;
		vert_W  = line_width*3;
    end
    
    if (~isempty(varargin))
        Screen('SelectStereoDrawBuffer', scr.wPtr, varargin{1});
        signDraw = 2*(varargin{1} - 0.5);
    end
   
    Screen('FillRect', scr.wPtr, scr.background);	
    
    % central square - same size as dots
	Screen('FillRect', scr.wPtr, scr.lwhite, ...
		[scr.xc_l - scr.fxDotRadius scr.yc_l - scr.fxDotRadius ...
		scr.xc_l + scr.fxDotRadius scr.yc_l + scr.fxDotRadius] );

	Screen('FillRect', scr.wPtr, scr.rwhite, ...
		[scr.xc_r - scr.fxDotRadius scr.yc_r - scr.fxDotRadius ...
		scr.xc_r + scr.fxDotRadius scr.yc_r + scr.fxDotRadius] );
	
    %% draw vertical lines
	Screen('DrawLine', scr.wPtr, scr.rwhite, scr.xc_r, scr.yc_r + signDraw*vert_R, ...
		scr.xc_r, scr.yc_r +signDraw*vert_W, vert_W);
    
%     %left display
% 	Screen('DrawLine', scr.wPtr, scr.lwhite, scr.xc_l, scr.yc_l + vert_R, ...
% 		scr.xc_l, scr.yc_l + vert_W, vert_W);
% 
	%% draw other lines and flip	
    if flipIt	
        % horizontal
		Screen('DrawLine', scr.wPtr, scr.rwhite, scr.xc_r +signDraw*(scr.signRight*scr.fxRadiusX), ...
			scr.yc_r, scr.xc_r + signDraw*(scr.signRight*scr.fxDotRadius + line_width), ...
			scr.yc_r , line_width);
	
% 		Screen('DrawLine', scr.wPtr, scr.lwhite, scr.xc_l + (scr.fxDotRadius + line_width), ...
% 			scr.yc_l, scr.xc_l + (scr.fxRadiusX), scr.yc_l, line_width);
	
		% diagonal
		Screen('DrawLine', scr.wPtr, scr.rwhite, scr.xc_r + signDraw*(scr.signRight*fxRadiusX2), ...
			scr.yc_r  - (scr.signRight*fxRadiusY2), ...
			scr.xc_r + signDraw*(scr.signRight*fxRadiusX2), ...
			scr.yc_r  - (scr.signRight*fxRadiusY2) , line_width);
	
		Screen('DrawLine', scr.wPtr, scr.rwhite, scr.xc_r + signDraw*(scr.signRight*fxRadiusX2), ...
			scr.yc_r  + signDraw*(scr.signRight*fxRadiusY2), ...
			scr.xc_r + signDraw*(scr.signRight*fxRadiusX2), ...
			scr.yc_r  - signDraw*(scr.signRight*fxRadiusY2) , line_width);
	
% 		Screen('DrawLine', scr.wPtr, scr.lwhite, scr.xc_l - (fxRadiusX2), ...
% 			scr.yc_l  - (fxRadiusY2), ...
% 			scr.xc_l + (fxRadiusX2), ...
% 			scr.yc_l  + (fxRadiusY2) , line_width);
% 	
% 		Screen('DrawLine', scr.wPtr, scr.lwhite, scr.xc_l - (fxRadiusX2), ...
% 			scr.yc_l  + (fxRadiusY2), ...
% 			scr.xc_l + (fxRadiusX2), ...
% 			scr.yc_l  - (fxRadiusY2) , line_width);
	
		Screen('Flip', scr.wPtr);
    end
end
