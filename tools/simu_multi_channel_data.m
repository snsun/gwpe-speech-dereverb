function wavout = simu_multi_channel_data( single_channel_wav_name , rir )
%SIMU_MULTI_CHANNEL_DATA is used to generate simulated multi-channel data
%   single_channel_wav_name: 
%   rir: M*len, M is channel number, len is length of RIR

[M, rir_len] = size(rir);
[wavin, fs] = audioread(single_channel_wav_name);
wav_len = size(wavin, 1);
wavout = zeros(wav_len, M);

for i = 1:M;
    tmp = conv(rir(i, :), wavin);
    wavout(:, i) = tmp(1:wav_len);
end

end

