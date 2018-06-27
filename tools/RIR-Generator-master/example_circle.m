c = 340;                    % Sound velocity (m/s)
fs = 16000;                 % Sample frequency (samples/s)
o = [2.5, 2, 1.5];          % Central position of mics array
R = 0.03;                   % Radius of the circle array (m)
M = 6;                      % Mic numbers
x = o(1)- R*sin([0:M-1]'*(2*pi/M));
y = o(2) + R*cos([0:M-1]'*(2*pi/M));
z = o(3)*ones(M, 1);

r = [x, y, z];              % Receiver positions [x_1 y_1 z_1 ; x_2 y_2 z_2;..] (m)
s = [2.5 3 1.5];              % Source position [x y z] (m)
L = [5 4 6];                % Room dimensions [x y z] (m)
beta = 0.00;                 % Reverberation time (s)
n = 1024;                   % Number of samples
mtype = 'omnidirectional';  % Type of microphone
order = -1;                 % -1 equals maximum reflection order!
dim = 3;                    % Room dimension
orientation = 0;            % Microphone orientation (rad)
hp_filter = 1;              % Enable high-pass filter

h = rir_generator(c, fs, r, s, L, beta, n, mtype, order, dim, orientation, hp_filter);
save('source', 'h');

s = [1, 2, 1.5];              % interface position [x y z] (m)
h = rir_generator(c, fs, r, s, L, beta, n, mtype, order, dim, orientation, hp_filter);
save('interface', 'h');