function stimset = UpDownLeftRight(videoMode)
% UP, DOWN, LEFT, RIGHT 2D motion

    fc = eval('SingleDot_dots');
    fc.handle = 'DotFrames';
    fc.name = 'Single Dot';
    
    
    params = {fc};
    
    directions = {'up', 'down', 'left', 'right'};
    
    stimset = cell(numel(params)*numel(directions), 1);
    c = 1;
    for p = 1: numel(params)
        for d = 1:numel(directions)
            info = params{p};
            info.direction = directions(d);            
            stimset{c}.fhandle = info.handle;
            stimset{c}.fparams = {info, videoMode};
            stimset{c}.info = info;
            c = c + 1;
        end
    end
end
