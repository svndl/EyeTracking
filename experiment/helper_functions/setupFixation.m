function fx = setupFixation(myScr)


    fx.fixationRadiusDeg   = 1;
    fx.fixationRadiusPix   = (60*fx.fixationRadiusDeg)/myScr.pix2arcmin;
    fx.fixationRadiusSqPix = fx.fixationRadiusPix^2;

    fx.fixationDotRadiusDeg = 0.125;
    fx.fixationDotRadiusPix = (60*fx.fixationDotRadiusDeg)/myScr.pix2arcmin;

    fx.fixationRadiusYPix = fx.fixationRadiusPix*myScr.Yscale;
    fx.fixationRadiusXPix = fx.fixationRadiusPix;
end