function nonius = getNoniusLines(cndInfo, scr)
% Function converts nonius lines's params from degrees to pixels
% or calculates default values for nonius lines.

% Input: 
% noniusInfo {1/0, struct} -- default (0, 1) or custom(struct) 
% settings for nonius lines;
%   noniusInfo.enable [1, 0] -- display nonius lines;
%   noniusInfo.color [0-255] -- nonius line color;  
%   noniusInfo.fixDotDeg [0 ..] -- fixation dot radius, degrees; 
%       (If it's 0, dot is not displayed).
%   nonius.widthDeg [0..] -- line width, degrees;
%   nonius.heightDeg [0..] -- line height, degrees;
%   nonius.upDeg [0-..] -- vertical offset from fixation dot.


% scr -- screen structure with conversion info;
% Output:

% nonius -- structure with nonius lines settings:
%   nonius.enable [1, 0] -- display nonius lines;
%   nonius.color [0-255] -- nonius line color;  
%   nonius.fxDotRadius [0 ..] -- fixation dot radius, pixels; 
%       (If it's 0, dot is not displayed).
%   nonius.vertW [0..] -- line width, pixels;
%   nonius.vertH [0..] -- line height, pixels;
%   nonius.vertS [0-..] -- vertical shift from 0, pixels.
    try 
        noniusInfo = cndInfo.nonius;
    catch
        noniusInfo = 0;
    end
    if (isstruct(noniusInfo))
        enable = noniusInfo.enable;
        vert_W = (60*noniusInfo.widthDeg)/scr.pix2arcmin;
        vert_H = (60*noniusInfo.heightDeg)/scr.pix2arcmin;
        fxDotRadius = (60*noniusInfo.fixDotDeg)/scr.pix2arcmin;
        vert_S = fxDotRadius + (60*noniusInfo.upDeg)/scr.pix2arcmin;
        color = noniusInfo.color;
    else
        enable = noniusInfo;
        line_width  = 2;
        fxDotRadius = scr.fxDotRadius;
        vert_W  = line_width*2;
        vert_H  = line_width*3;        
        vert_S = scr.fxRadiusY*2;
        color = scr.white;
    end
    nonius.enable = enable;
    nonius.vertW = vert_W;
    nonius.vertH = vert_H;
    nonius.vertS = vert_S;
    nonius.fxDotRadius = fxDotRadius;
    nonius.color = color;
end

