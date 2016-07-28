function ds = directionSigns(direction, eye)
    
    switch char(direction)
        case 'towards'
            signs.L = 1;
            signs.R = -1;
        case 'away'
            signs.L = -1;
            signs.R = 1;
        case {'up', 'left'}
            signs.L = -1;
            signs.R = -1;
        case {'down', 'right'}
            signs.L = 1;
            signs.R = 1;
    end
    ds = signs.(eye);
end
