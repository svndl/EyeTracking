function drawStimulus(scrPtr, xc, yc, eye, barTexture, scrCenter, nonius)
% drawing dots + nonius on one stereo screen.
% Input: 
% scrPtr -- pointer to PTB Screen;
% [xc, yc] -- nonius line center;
% eye {'L', 'R'}, defines stereo buffer and nonius line shift sign;
% dots -- XY coordinates of dots;
% dotSize -- dot size (applied to all);
% dotColor -- dot color (aplpied to all);
% scrCenter -- [x0 y0] corrdinatess of screen center;
% nonius -- structure with nonius lines settings:
%   nonius.enable [1, 0] -- display nonius lines;
%   nonius.color [0-255] -- nonius line color;  
%   nonius.fxDotRadius [0 ..] -- fixation dot radius, pixels; 
%       (If it's 0, dot is not displayed).
%   nonius.vertW [0..] -- line width, pixels;
%   nonius.vertH [0..] -- line height, pixels;
%   nonius.vertS [0-..] -- vertical shift from 0, pixels. 


    % L/R screen ID
    stereoBufferID = 0;
    signShift = -1;

    if (eye == 'R')
        stereoBufferID = 1;
        signShift = 1;
    end;
    
    % workaround removing the center still dot
    

    Screen('SelectStereoDrawBuffer', scrPtr, stereoBufferID);
    Screen('DrawTexture',scrPtr,barTexture);

   
%     % nonius lines
%     if (nonius.enable)
%         if (nonius.fxDotRadius > 0)
%             Screen('FillRect', scrPtr, nonius.color, ...
%                 [xc - nonius.fxDotRadius yc + nonius.fxDotRadius ...
%                 xc + nonius.fxDotRadius yc + nonius.fxDotRadius] );
%         end
%         Screen('DrawLine', scrPtr, nonius.color, xc, ...
%             yc + signShift*nonius.vertS, ...
%             xc, yc + signShift*(nonius.vertH + nonius.vertS), nonius.vertW);
%     end
end