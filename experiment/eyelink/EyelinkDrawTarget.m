function [rectL, rectR] = EyelinkDrawTarget(el, x, y)

% draw simple calibration target
%
% USAGE: rect=EyelinkDrawTarget(el, x, y)
%
%		el: eyelink default values
%		x,y: position at which it should be drawn
%		rect: 

	[width, ~] = Screen('WindowSize', el.window);
	size2 = round(el.calibrationtargetsize/100*width);
    rect = CenterRectOnPoint([0 0 size2 size2], x, y);
    
    % left screen
    Screen('SelectStereoDrawBuffer', scr.wPtr, 0);    
	Screen( 'FillOval', el.window, [0 el.foregroundcolour(1) el.foregroundcolour(1)],  rect );
	Screen( 'FillOval', el.window, [el.foregroundcolour(1) 0 0],  rect );
    %right screen
    Screen('SelectStereoDrawBuffer', scr.wPtr, 1);    
	Screen( 'FillOval', el.window, [0 el.foregroundcolour(1) el.foregroundcolour(1)],  rect );
	Screen( 'FillOval', el.window, [el.foregroundcolour(1) 0 0],  rect );
    
    % do the flip
	Screen( 'Flip',  el.window);
end