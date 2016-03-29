function ds = directionSigns(direction, eye)
    
    switch direction
        case 'away'
            signs.L = 1;
            signs.R = -1;
        case 'towards'
            signs.L = -1;
            signs.R = 1;
        case 'left'
            signs.L = -1;
            signs.R = -1;
        case 'righ'
            signs.L = 1;
            signs.R = 1;
    end
    ds = signs.(eye);
end
