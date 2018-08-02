addpath('tools/')
addpath('dereverb/');
wav_name = 'r_female_07_4ch.wav';
wav_dir='./wav_example/';

% read multichannel reverberant speech
multi_channel_wav=[wav_dir wav_name];
[multi_wav, fs] = audioread(multi_channel_wav);

% fft config
fft_config.frame_len = 512;
fft_config.frame_shift = 128;
fft_config.fft_len = fft_config.frame_len ;

% GWPE config
gwpe_config.K = 10;
gwpe_config.delta=3;
gwpe_config.iterations = 3; 

% GWPE dereverb
[original_spec, dereverb_spec,dereverb_wav,  weight ] = GWPE( multi_wav, gwpe_config, fft_config);
%[~, ~,dereverb_wav, ~ ] = GWPE( multi_wav, gwpe_config, fft_config);
audiowrite([wav_dir 'dereverb_' wav_name], dereverb_wav, fs);

% Show 
subplot(2,1,1);
imagesc(flipud(squeeze(log(abs(dereverb_spec(1,:, :))))'));title('Dereverbed')
subplot(2,1,2)
imagesc(flipud(squeeze(log(abs(original_spec(1,:, :))))'));title('Reverberant')
