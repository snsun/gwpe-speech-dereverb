%% Author Sining Sun (NWPU)
% snsun@nwpu-aslp.org

function [wav, bf_spec] = bf_and_reconstruct(W, ffts, config)
%% This function is used to do beamforming and  reconstruct wav using overlap and add.
% W: BF coefficients
% ffts: M*T*F complex matrix, enhaced spectrum where T is frame number and
% F is frequency bin number (fft_len/2 + 1), M is channel number;
%
%  wav, reconstructed wavform.
%  bf_spec: enhanced spectrum

    [M, T, F] = size(ffts); %M: Channel number, T: Frame number, F: Freq bin number
    if (M ~= config.sensor_number)
        error(message('Sensor number is not equal to ffts\n'));
    end
    
    bf_spec = zeros(T, F);    %beamforming outputs
    cut_freq_index=config.cut_freq_index;
    for t=1:T
        bf_spec(t, cut_freq_index:end) = mean(conj(W(cut_freq_index:end,:)) .* squeeze(ffts(:, t, cut_freq_index:end)).', 2);
    end
    bf_spec = [bf_spec, fliplr(conj(bf_spec(:, 2:end-1)))];
    rec_frames = real(ifft(bf_spec, config.fft_len, 2));
    rec_frames = rec_frames(:,1:config.frame_len);
    wav = overlapadd(rec_frames, hamming(config.frame_len, 'periodic'), config.frame_shift);

    