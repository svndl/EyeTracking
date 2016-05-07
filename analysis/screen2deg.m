function screen2deg = screen2deg(pos, el, ipd)
    screen2deg = atand(((ipd/2) + pos)./el.href_dist);
end