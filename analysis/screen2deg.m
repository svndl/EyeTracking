function screen2deg = screen2deg(pos, el, ipd)
    %screen2deg = atand(((ipd/2) + pos)./el.href_dist);
    xy = (0.5*ipd + pos)./el.href_dist;
    screen2deg = atan2d(xy(:, 2), xy(:, 1));
end