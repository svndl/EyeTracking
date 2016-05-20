function dspl = LG_OLED_TB
    % LG OLED 3D TV
    dspl.name           = 'LG_OLED_TB';
    dspl.viewDistCm     = 80;

    dspl.width_cm       = 120;
    dspl.height_cm      = 70;

    dspl.loadDistortion = 0;
    dspl.snellShiftPix  = 0;

    dspl.prismShiftCm   = 0;
    dspl.stimCenterYCm  = 0;

    dspl.leftright      = 0;
    dspl.topbottom      = 1;

    dspl.skipSync       = 1;
    dspl.signRight      = 1;
    
    dspl.white = 180;
    dspl.gray = 127;
    dspl.black = 0;
end