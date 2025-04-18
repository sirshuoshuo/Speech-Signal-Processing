
    [x, fs] = audioread('test_16k.wav');
    x = x(:, 1); 
  
    start_sample = 6000;
    frame_size = 640;
    order = 12;
    frame = x(start_sample : start_sample + frame_size - 1);
    [a, errsig] = LPC(frame, order);
    nfft = 2048;
    freq = (0:nfft/2) * fs / nfft; 
    spec_orig = abs(fft(frame, nfft));
    spec_orig = 20*log10(spec_orig(1:nfft/2+1));
  
    [h, ~] = freqz(1, [1; -a], nfft/2+1, fs);
    spec_lpc = 20*log10(abs(h));
    spec_err = abs(fft(errsig, nfft));
    spec_err = 20*log10(spec_err(1:nfft/2+1));
    
    figure('Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.8]);
    subplot(2,2,1);
    plot((0:frame_size-1)/fs, frame);
    title('Original Speech Frame');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
    
    subplot(2,2,2);
    plot((0:frame_size-1)/fs, errsig);
    title('LPC Error Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
    
    subplot(2,2,3);
    plot(freq, spec_orig, 'b', 'LineWidth', 1.5);
    hold on;
    plot(freq, spec_lpc, 'r', 'LineWidth', 1.5);
    hold off;
    title('Spectrum Comparison');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    legend('Original Signal', 'LPC Spectrum');
    grid on;
    ylim([-50, max(spec_orig)+10]);
    
    subplot(2,2,4);
    plot(freq, spec_err);
    title('Error Signal Spectrum');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    grid on;
    saveas(gcf, 'D:/作业提交/大三 下/语音信号处理/lab7/P1.png', 'png')