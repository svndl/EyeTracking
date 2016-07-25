function [keys, sound, scr, el] = setupDevices(display)
    %setup devices

    displayParams = eval(display);	
    keys = setupKeyboard;
    sound = setupSound;
    scr = setupVideoMode(displayParams);
    el = EyelinkSetup(scr);
end
