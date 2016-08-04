function [xc, yc] = convertColor(inputColor)
    switch (inputColor)
        case 'r'
            xc = [ 240 20 20 ];
            yc = [ 200 50 150 ];
        case 'b'
            xc = [ 20 20 240 ];
            yc = [ 0 174 239 ];
        case 'k'
            xc = [ 170 120 140 ];
            yc = [ 125 120 125 ];
        case 'g'
            xc = [ 176 215 176 ];
            yc = [ 76 255 74 ];
    end
    xc = xc/255;
    yc = yc/255;
end