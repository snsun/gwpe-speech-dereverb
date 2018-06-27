c = 340;                    % Sound velocity (m/s)
fs = 16000;                 % Sample frequency (samples/s)
ax = 2; ay=2; az=2;
M = 4;
mic_dis = 0.035;
angle = 180;
theta = angle /180*pi;
mic_poistion = zeros(3, M);
mic_position(:, 1) = ax+mic_dis*(0:M-1);% Receiver positions [x_1 y_1 z_1 ; x_2 y_2 z_2] (m)
mic_position(:, 2) = ay;
mic_position(:, 3) = az;
mic_centre = [ax+mic_dis*(M/2-0.5), ay, az];
spker_dis = 1;
spker_position = [mic_centre(1)*(1-cos(theta)), mic_centre(2)*(1-sin(theta)), az];% Source position [x y z] (m)

             
L = [5 4 6];                % Room dimensions [x y z] (m)
beta = 0.0;                 % Reverberation time (s)
n = 1024;                 % Number of samples
mtype = 'omnidirectional';  % Type of microphone
order = -1;                 % -1 equals maximum reflection order!
dim = 3;                    % Room dimension
orientation = 0;            % Microphone orientation (rad)
hp_filter = 1;              % Enable high-pass filter

h = rir_generator(c, fs, mic_position, spker_position, L, beta, n, mtype, order, dim, orientation, hp_filter);