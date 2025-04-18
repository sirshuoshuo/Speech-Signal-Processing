[aud, fs] = audioread('s5.wav');
lpc_size = 320;
lpc_shift = 80;
lpc_order = 12;

% 确保aud是列向量
aud = aud(:);

% 使用buffer函数将信号分帧
y = buffer(aud, lpc_size, lpc_size - lpc_shift, 'nodelay'); % 320x297
num_frames = size(y, 2); % 一共有297帧

% 创建汉宁窗
hann_win = hann(lpc_size, "periodic"); % 帧长度为320

% 初始化变量
est_frames = zeros(lpc_size, num_frames); % 复原后的帧
residual = zeros(lpc_size, num_frames);   % 残差
a_coeffs = zeros(num_frames, lpc_order + 1); 

history_buffer = zeros(lpc_order, 1); % 初始化历史缓冲区

for i = 1:num_frames
    frame = y(:, i); % 当前帧, 320x1
    % 对当前帧加窗
    windowed_frame = frame .* hann_win; % 320x1

    R = xcorr(windowed_frame, lpc_order, 'unbiased'); % 计算自相关
    R = R(lpc_order + 1:end); % 取出自相关系数, 13x1
    R = R(:); % 确保是列向量
    % 计算LPC系数
    [a_coeffs(i, :), ~] = levinson(R, lpc_order); % 1x13

    extended_frame = [history_buffer; frame];

    pred_signal = filter([0 -a_coeffs(i, 2:end)], 1, extended_frame);
    
    % 只取当前帧部分的预测结果
    est_frames(:, i) = pred_signal(lpc_order+1:end);
    
    % 计算残差
    residual(:, i) = frame - est_frames(:, i);
    
    % 更新历史缓冲区用于下一帧
    history_buffer = frame(end-lpc_order+1:end);

end

reconstructed_signal = zeros(length(aud),1);
residual_sum = zeros(length(aud), 1);
prediction = zeros(length(aud),1);
count = zeros(length(aud), 1);


for i = 1:num_frames
    % 计算当前帧在原信号中的位置
    start_idx = (i-1) * lpc_shift + 1;
    end_idx = start_idx + lpc_size - 1;
    
    if end_idx <= length(reconstructed_signal)
        % 结合预测信号和残差来重构原始信号
        % s(n) = 预测信号 + 残差
        frame_reconstruction = est_frames(:,i) + residual(:,i);
        
        % 将重构帧添加到重构信号
        reconstructed_signal(start_idx:end_idx) = reconstructed_signal(start_idx:end_idx) + frame_reconstruction;
        residual_sum(start_idx:end_idx) = residual_sum(start_idx:end_idx) + residual(:, i);
        prediction(start_idx:end_idx) = prediction(start_idx:end_idx) + est_frames(:, i);
        count(start_idx:end_idx) = count(start_idx:end_idx) + 1;
    end
end


figure;
subplot(3,1,1);
plot(aud);
title('Original Signal');
xlabel('Sample');
ylabel('Amplitude');

subplot(3,1,2);
plot(reconstructed_signal);
title('Reconstructed Signal');
xlabel('Sample');
ylabel('Amplitude');

subplot(3,1,3);
plot(residual_sum);
title('Residual Signal');
xlabel('Sample');
ylabel('Amplitude');











