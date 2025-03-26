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

% ����sampling rate�ĸı䣺������Խ�󣬿ɷ�����Ƶ�ʷ�ΧԽ�����Ա�������ĸ�Ƶϸ�ڡ����������ʵ���Nyquist rateʱ�������Ƿ�����޷���ԭ����ͼ���ı�����ʵ�ͬʱҲ��ı䴰��
% ���������ĳ���ֻҪ������������Ƶ���ϵķֱ��ʡ�����Խ����ʱ���Ϸֱ���Խ�ͣ�Ƶ���ϵķֱ���Խ��
% nfft��nfft����ֱ��Ӱ��Ƶ���ϵķֱ��ʣ�����nfft����ʱ�����ڹ۲칲��壬�����׽�Ϊƽ����nfft��Сʱ�����׽�Ϊ�ֲ�