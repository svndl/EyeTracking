function sound =  setupSound
% set up sound params

	cf = 1000;                  % carrier frequency (Hz)
	sf = 22050;                 % sample frequency (Hz)
	d = 0.1;                    % duration (s)
	n = sf * d;                 % number of samples
	s = (1:n) / sf;             % sound data preparation
	s = sin(2 * pi * cf * s);   % sinusoidal modulation
	sound.s = s;
	sound.sf = sf;

	cf = 2000;                  % carrier frequency (Hz)
	sf = 22050;                 % sample frequency (Hz)
	d = 0.1;                    % duration (s)
	n = sf * d;                 % number of samples
	s = (1:n) / sf;             % sound data preparation
	s = sin(2 * pi * cf * s);   % sinusoidal modulation
	sound.sFeedback = s;
	sound.sfFeedback = sf;
end