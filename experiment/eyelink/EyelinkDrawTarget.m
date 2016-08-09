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
    Screen('SelectStereoDrawBuffer', el.window, 0);    
	Screen( 'FillOval', el.window, el.foregroundcolor, rect );
	Screen( 'FillOval', el.window, el.foregroundcolor, rect );
    %right screen
    Screen('SelectStereoDrawBuffer', el.window, 1);
	Screen( 'FillOval', el.window, el.foregroundcolor, rect );
	Screen( 'FillOval', el.window, el.foregroundcolor, rect );
    
    % do the flip
	Screen( 'Flip',  el.window);
end