STSA_Spectrogram('s5.wav', 0, [5, 50], [1024, 1024], "log", 60, 3);
% [y,fs] = audioread('s5.wav')
% % change resampling rate
STSA_Spectrogram('s5.wav', 16000, [5, 50], [1024, 1024], "log", 60, 2);
STSA_Spectrogram('s5.wav', 32000, [5, 50], [1024, 1024], "log", 60, 2);
STSA_Spectrogram('s5.wav', 40000, [5, 50], [1024, 1024], "log", 60, 2);

% change window length
STSA_Spectrogram('s5.wav', 16000, [2, 25], [1024, 1024], "log", 60, 2);
STSA_Spectrogram('s5.wav', 16000, [5, 50], [1024, 1024], "log", 60, 2);
STSA_Spectrogram('s5.wav', 16000, [10, 100], [1024, 1024], "log", 60, 2);

% change nfft number, change to linear mod
STSA_Spectrogram('s5.wav', 16000, [5, 50], [20, 100], "log", 60, 2);
STSA_Spectrogram('s5.wav', 16000, [5, 50], [1024, 1024], "linear", 120, 2);
STSA_Spectrogram('s5.wav', 16000, [5, 50], [2048, 4096], "linear", 120, 2);

% 对于sampling rate的改变：采样率越大，可分析的频率范围越宽，可以保留更多的高频细节。但当采样率低于Nyquist rate时，会出现欠采样无法还原语谱图。改变采样率的同时也会改变窗长
% 窗长：窗的长度只要是限制语谱在频率上的分辨率。窗长越长，时间上分别率越低，频率上的分别率越高
% nfft：nfft不会直接影响频率上的分辨率，但是nfft更高时更利于观察共振峰，且语谱较为平滑。nfft较小时，语谱较为粗糙