function [waveform, zero_crossing, time_axis] = ZCA(y, fs, R, win)
% R = shift in sample
% 窗长度和win的长度一致

% 输入参数检查
L = length(win); % 窗口长度（帧长）

% 初始化输出
waveform = y; % 原始波形

% 分帧并加窗处理（使用nodelay避免初始延迟）
frames = buffer(y, L, L-R, 'nodelay');  % 分帧，维度 [L x num_frames]
num_frames = size(frames, 2);           % 总帧数

zero_crossing = zeros(1, num_frames);   % 短时过零率

for i = 1:num_frames
    frame = frames(:, i); % 取出一帧

    % % 加窗
    frame = frame .* win;

    % 计算短时过零率
    zero_crossing(i) = sum(abs(diff(frame > 0))) / (L-1);
end

time_axis = (0:num_frames-1) * (R/fs);

end