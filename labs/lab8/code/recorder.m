fs = 16000;             % 采样率 16 kHz
duration = 3;           % 录音时长 5 秒
recObj = audiorecorder(fs, 16, 1); % 16位深度，单声道

disp('开始录音...');
record(recObj);         % 开始录音
pause(duration);        % 等待录音完成
stop(recObj);           % 停止录音

audioData = getaudiodata(recObj); % 获取录音数据
audiowrite('recording.wav', audioData, fs); % 保存为WAV文件
