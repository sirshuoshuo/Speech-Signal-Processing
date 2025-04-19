function [pitch_vector, confidence_vector, unfilt_pitch, unfilt_conf] = PitchDetector_Autocorrelation(aud, fs, gender)
%UNTITLED 基于自相关的音调检测器。
% gender: 0: female; 1: male;
% s is the read audio vector.

fsout = 10000;

y = resample(aud, fsout, fs);
y = y/max(abs(y));

Filt_task1 = load("Filt_task1.mat", "-mat").Filt_task1;

y_filt = filter(Filt_task1, 1, y);

if ~exist("task2_aud", "dir")
    mkdir("task2_aud")
end

audiowrite("task2_aud/Filtered.wav", y_filt, fsout);
audiowrite("task2_aud/Original.wav", y, fsout);

% sound(y_filt, fsout);
% sound(y, fsout);

L = 400;
R = 100;

frames = buffer(y_filt, L, L - R, "nodelay");
num_frames = size(frames, 2);

estimated_pitch = zeros(num_frames, 1);
estimation_confidence = zeros(num_frames, 1);
unfilt_pitch = zeros(num_frames, 1);
unfilt_conf = zeros(num_frames, 1);

if gender == 0
    pdhigh = floor(fsout / 150);
    pdlow = ceil(fsout / 300);
elseif gender == 1
    pdhigh = floor(fsout / 75);
    pdlow = ceil(fsout / 200);
end

frames = buffer([y_filt; zeros(L, 1)], L, L - R, "nodelay");
unfilt_frames = buffer([y; zeros(L, 1)], L, L - R, "nodelay");


for i = 1:num_frames-1
    frame = frames(:, i);
    unfilt_frame = unfilt_frames(:, i);

    nextframe = frames(:, i+1);
    unfilt_nextframe = unfilt_frames(:, i+1);

    s1 = frame;
    s2 = [frame; nextframe(1:pdhigh)];
    s1_unfilt = unfilt_frame;
    s2_unfilt = [unfilt_frame; unfilt_nextframe(1:pdhigh)];

    correlation = xcorr(s1, s2, 'none');
    correlation = correlation(length(s2):end);

    unfilt_correlation = xcorr(s1_unfilt, s2_unfilt, 'none');
    unfilt_correlation = unfilt_correlation(length(s2_unfilt):end);

    [max_val, max_idx] = max(correlation(pdlow:pdhigh));
    max_idx = max_idx + pdlow - 1;  % 调整索引以匹配原始correlation数组

    [max_val_unfilt, max_idx_unfilt] = max(unfilt_correlation(pdlow:pdhigh));
    max_idx_unfilt = max_idx_unfilt + pdlow - 1;  % 调整索引以匹配原始correlation数组

    estimated_pitch(i) = fsout / max_idx;  % 计算音高
    estimation_confidence(i) = max_val;  % 计算置信度

    unfilt_pitch(i) = fs / max_idx_unfilt;  % 计算未滤波音高
    unfilt_conf(i) = max_val_unfilt;  % 计算未滤波置信度

end

log_confidence = log10(estimation_confidence);
max_log_confidence = max(log_confidence);
threshold = 0.75*max_log_confidence;
estimated_pitch(log_confidence < threshold) = 0;  % 将低置信度的音高设为0

log_confidence_unfilt = log10(unfilt_conf);
max_log_confidence_unfilt = max(log_confidence_unfilt);
threshold_unfilt = 0.75*max_log_confidence_unfilt;
unfilt_pitch(log_confidence_unfilt < threshold_unfilt) = 0;  % 将低置信度的音高设为0

pitch_vector = estimated_pitch;
confidence_vector = log_confidence;

unfilt_conf = log_confidence_unfilt;

end

