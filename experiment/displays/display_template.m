function dspl = display_template

    dspl.name           = 'template';
    dspl.viewDistCm        = 77;                              % distance subject views from

    dspl.width_cm          = 54.3;                            % display width
    dspl.height_cm         = 30.6;                            % display height

    dspl.loadDistortion    = 1;                               % load distortion file for haploscope
    dspl.snellShiftPix     = 3;                               % shift red and blue values to correct for prisms (determined by eye)

    dspl.prismShiftCm      = 0;                               % left/right image shift to center in prisms

    dspl.stimCenterYCm     = 0;                               % height adjustment of stimulus to center in prisms

    dspl.topbottom         = 0;                               % does this display take top/bottom stereo format

    dspl.skipSync          = 0;                               % 0 if this is a testing display that PTB doesn't like timing of
    dspl.signRight         = 1;                               % 1 if displays are oriented the same, -1 if displays are mirrored
end