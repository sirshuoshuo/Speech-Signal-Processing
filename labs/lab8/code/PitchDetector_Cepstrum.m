function [pitch_period_smooth, confidence_smooth] = PitchDetector_Cepstrum(s, fs, gender)    
    % 重采样
    Fs = 10000;
    s = resample(s, Fs, fs);
    nfft = 4000;
%     s = hamming(length(s));

    if gender == 1
        nlow = 40;
        nhigh = 167;
%         nlow = Fs/200;
%         nhigh = Fs/75;
    elseif gender == 0
        nlow = 28;
        nhigh = 67;
    end
    
    % 分帧
    frame_length = 400;  
    frame_shift = 100;   
    nframe = floor((length(s) - frame_length)/frame_shift) + 1;
    primary_pitch = zeros(1, nframe);
    secondary_pitch = zeros(1, nframe);
    pitch_period = zeros(1, nframe);
    confidence = zeros(1, nframe);
    pthrl = 4;
    
    % 倒谱分析
    for i=1:nframe
        begin = (i-1)*frame_shift + 1;
        frame = s(begin:begin+frame_length-1);
        frame = frame .* hamming(length(frame));
        
        % 取倒谱
        min_sample = round(Fs/nhigh);
        max_sample = round(Fs/nlow);
        spectrum = fft(frame, nfft);
        cepstrum = abs(real(ifft(log(abs(spectrum) + eps))));
        cepstrum = cepstrum(min_sample:max_sample)   % 限定查找范围
        
        % 取两个主峰
        [p1, pd1] = max(cepstrum)   % 第一峰，取绝对值
        zero_range = max(1,pd1-4):min(length(s), pd1+4);
        primary_pitch(i) = p1;
        cepstrum(zero_range) = 0;
        [p2, pd2] = max(cepstrum)   % 第二峰
        secondary_pitch(i) = p2;
        p1/p2;
        cepstrum;
        
        % 判断reliable区域
        if p1/p2 > pthrl
%             pitch_period(i) = (pd2+pd1)/2;
            pitch_period(i) = pd1;
            confidence(i) = p1/p2;
        else
            pitch_period(i) = 0;   % 不可靠帧
        end
    end   % end for
    
        pitch_period(i)
%         confidence(i)
    
    % 扩展区域
    for i=2:nframe-1
        if pitch_period(i-1)~=0 && abs((pitch_period(i)-pitch_period(i-1))) < 0.1   % 向后拓展
            pitch_period(i-1) = pitch_period(i);
        end
        if pitch_period(i+1)~=0 && abs((pitch_period(i+1)-pitch_period(i))) < 0.1   % 向前扩展
            pitch_period(i+1) = pitch_period(i);
        end
    end
    
    % 平滑处理
    pitch_period_smooth = MedianSmoother(pitch_period, 5);
    confidence_smooth = MedianSmoother(confidence, 5);
%     pitch_period_smooth = pitch_period;
%     confidence_smooth = confidence;
%     pitch_period_smooth = medfilt1(pitch_period, 5);
%     confidence_smooth = medfilt1(confidence, 5);
    
end   % end function
