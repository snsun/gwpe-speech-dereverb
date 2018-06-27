%% Author Sining Sun (NWPU)
% snsun@nwpu-aslp.org

function [BeamPattern, WNG]=beampattern(W, config)
%% This function is used to calculate BeamPattern given bf coefficients
%   and config.

N = config.sensor_number;                  % Number of mics 
dis = config.sensor_spacing;            % Distance between reference mic and other mics
c = config.c;
steering_vector = config.steering_vector.';

space_res = config.space_resolution;
f = config.anglar_frequency;
angulars = 0:space_res:pi;
F = size(f, 1);                    %Number of frequency bins
S = size(angulars, 2);             %Number of space angulars
Dis = dis';
Dis = repmat(Dis, 1, S);
T = cos(angulars)/c;
T = repmat(T, N, 1);
Tau = Dis.*T;  %time delay from different directions
desire_direction = config.incident_angle;  % Steering direction in degree

B = zeros(F, S);
WNG = zeros(F,1);

for p = 1:F
    G = exp(-1i*f(p)*Tau.');
    sv = steering_vector(:, p);
    wf = W(p, :).';
    B(p, :) = G * conj(wf);
    WNG(p) = (abs(norm(wf'*sv,2)))^2 / (wf' * wf);
end

WNG=10*log(WNG);
BeamPattern = 20*log(abs(B));


if config.plot
           % Plot
        figure(config.stage)
        
        subplot(2,2,[1,3]);      
        mesh(BeamPattern);title(['BeamPattern of ' config.bfmethod]);
        subplot(2,2,2);
        p=[50 100 150 200];
        freqs = p/config.fft_len*config.fs;
        h1=polar(angulars,min(abs(B(p(1),:)),1), 'r'); hold on
        h2=polar(angulars,min(abs(B(p(2), :)),1), 'b'); 
        h3=polar(angulars,min(abs(B(p(3), :)),1), 'y'); 
        h4=polar(angulars,min(abs(B(p(4), :)), 1), 'g'); 
        legend([h1,h2,h3,h4], [num2str(freqs(1)) 'Hz'], [num2str(freqs(2)) 'Hz'],...
         [num2str(freqs(3)) 'Hz'],[num2str(freqs(4)) 'Hz']);
        grid on; grid minor
        subplot(224);
        
        plot(WNG);title(['WNG of ' config.bfmethod])
        %Plot Done!
end