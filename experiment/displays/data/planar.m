function dspl = planar

    dspl.name           = 'planar';
    dspl.viewDistCm     = 50;

    %fixed dspleen width to handle native resolution
    dspl.width_cm       = 45.8399; % *True* width is 55.008
    dspl.height_cm      = 34.38;

    dspl.loadDistortion = 0;
    dspl.snellShiftPix  = 0;

    dspl.prismShiftCm   = 0;
    dspl.stimCenterYCm  = 0;

    dspl.topbottom      = 0;
    dspl.leftright      = 0;

    dspl.skipSync       = 1;
    dspl.signRight      = -1;             % displays are mirrored so flip the right image
end

