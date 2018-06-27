function [original_spec, dereverb_spec, dereverb_wav, weight ] = GWPE( wav, gwpe_config, fft_config)
%GWPE This is ann implementation of Generalization of Multi-Channel Linear
%     Prediciton Methods for Blind MIMO Impulse Response Shortening
%   input: 
%       wav: num_sample * num_channel
%       gwpe_config:
%           gwpe_config.K: prediction order (eg. K=10)
%           gwpe_config.delta: delay (eg. delta = 2)
%           gwpe_config.iterations: total interation number (eg. interations = 5)
%       fft_config:
%           fft_config.frame_len
%           fft_config.frame_shift
%           fft_config.fft_len 
%   output:
%       original_spec: multi-channel spectrum of original speech
%       dereverb_spec: multi-channel spectrum after dereverb
%       dereverb_wav: multi-channel enhanced time domain signals
%       weight: desired fileter coefficients  

% Reference: Yoshioka, Takuya, and Tomohiro Nakatani. 
%           "Generalization of multi-channel linear prediction methods for blind MIMO impulse response shortening." 
%           IEEE Transactions on Audio, Speech, and Language Processing 20.10 (2012): 2707-2720.
%   

%   
%   Author: Sining Sun (Northwetern Polytechnical Univercity)

frame_len = fft_config.frame_len;
frame_shift = fft_config.frame_shift;
fft_len = fft_config.fft_len;

K = gwpe_config.K;
delta = gwpe_config.delta;
iterations = gwpe_config.iterations;

[frames, ffts] = multi_fft(wav, frame_len, frame_shift, fft_len);
[N, T, L] = size(ffts); %ffts shape: Channel * Frame * Freqbin
x = ffts;


G = zeros(L, N*N, K);
for iter=1:iterations
    % V-B Scaled Identity Matrix Method is used here
    G = zeros(L, N*N, K);

    lambda = mean(abs(x).^2, 1); % T*L
    invlambda = 1 ./ max(lambda, 0.00001); 
    for ll = 1:L
        y = squeeze(ffts(:, :, ll)); %N*T
        tmp = enframe(y(1,:) ,ones(1, K), 1); % 
        tmp = fliplr(tmp); % keep consistent with Y(t), ..., Y(t-K+1)
        sT = size(tmp, 1);
        segments = zeros(N, K, sT);
        segments(1, :, :) = tmp.';
        for n = 2:N
            tmp = enframe(y(n,:) ,ones(1, K), 1);
            tmp = fliplr(tmp); 
            segments(n, :, :)= tmp.';    
        end
        segments = reshape(segments, N*K, sT);
        invlambda_l = invlambda(1,delta+K:min(delta+K+sT-1, T), ll);
        invlambda_vec = repmat(invlambda_l, [N*K, 1]);
        sT2 = size(invlambda_l, 2);
        invlambda_l = reshape(invlambda_l, [1, 1, sT2]);
        invlambda_mat = repmat(invlambda_l, [N*K, N*K, 1]);
        
        R = outProdND(conj(segments(:, 1:sT2)));
        R = R .* invlambda_mat;
        R = sum(R, 3);
        for i = 1:N
            r = repmat(y(i, delta+K:sT2+delta+K-1), N*K, 1) .* conj(segments(:, 1:sT2)) .* invlambda_vec; 
            r = sum(r, 2);
            g = linsolve(R+eye(N*K)*0.00001, r);
            g = conj(g);
            g = reshape(g, N, K);
            G(ll, (i-1)*N+1:i*N, :) = g;
        end
        errors = zeros(N, T);
        for t=delta+K:T
            for k = 1:K
                tmpG = G(ll, :, k);
                tmpG = reshape(tmpG, N, N);
                errors(:, t) = errors(:, t) + tmpG' * y(:, t-delta-k+1); %(4)
            end
        end
        x(:, :, ll) = y - errors;  %(5)
    end
end

dereverb_spec=x;
weight =G;
original_spec = ffts;

%Overlap and add
enhanced_wav = cell(1, N);
for i=1:size(dereverb_spec, 1)
    spec = squeeze(dereverb_spec(i, :, :));
    enhanced_frames = irfft(spec, fft_len, 2);
    enhanced_wav{i} = overlapadd(enhanced_frames, hamming(fft_len), frame_shift);
end

dereverb_wav = cell2mat(enhanced_wav);

end

