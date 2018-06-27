function [factor] = add_noise( X, Noise, SNR, fs, noise_start)
%Example Y = add_noise(wav, noise, 5, 16000, 30)

%X : clean speech data
%Noise : noise data
%SNR: signal-to-noise ratio
%fs: sample rate
%noise_start: start point in the noise. 
%Make sure that 'noise_start +len(X) < len(Noise)
%
%Y: noisy data with the SNR

%Get the noise signal has the same length with X
lenX = size(X, 1); %语音信号长度
noise = Noise(noise_start: noise_start + lenX -1); %截取相同长度噪声
E_X = sum(X.^2); %原始语音信号能量
E_N1 = sum(noise.^2); %噪声能量
E_N2 = E_X/(10^(SNR/10)); 
factor = sqrt(E_N2/E_N1);
noise_add = factor * noise;
Y = noise_add + X;
end

