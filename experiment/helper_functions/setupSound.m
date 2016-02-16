function snd = setupSound
    %% SOUND %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    cf = 1000;                  % carrier frequency (Hz)
    sf = 22050;                 % sample frequency (Hz)
    d = 0.1;                    % duration (s)
    n = sf * d;                 % number of samples
    s = (1:n) / sf;             % sound data preparation
    s = sin(2 * pi * cf * s);   % sinusoidal modulation
    snd.s = s;
    snd.sf = sf;

    cf = 2000;                  % carrier frequency (Hz)
    sf = 22050;                 % sample frequency (Hz)
    d = 0.1;                    % duration (s)
    n = sf * d;                 % number of samples
    s = (1:n) / sf;             % sound data preparation
    s = sin(2 * pi * cf * s);   % sinusoidal modulation
    snd.sFeedback = s;
    snd.sfFeedback = sf;
end