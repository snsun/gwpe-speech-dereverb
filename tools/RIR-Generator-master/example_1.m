c = 340;                    % Sound velocity (m/s)
fs = 16000;                 % Sample frequency (samples/s)
r = [2.5 2 3;2.6 2 3;2.7 2 3;2.8 2 3];              % Receiver position [x y z] (m)
s = [1.65 2 3];              % Source position [x y z] (m)
L = [5 4 6];                % Room dimensions [x y z] (m)
beta = 0.0;                 % Reverberation time (s)
n = 128;                   % Number of samples

h = rir_generator(c, fs, r, s, L, beta, n);