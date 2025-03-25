function STSA_MultiLengths(num, filename, startsmp, framelengths)
    [aud, fs] = audioread(filename);

    colors = lines(num);

    figure(1)
    sgtitle('Short-Time Analysis, with Hamming Window, Variable Frame Lengths');
    subplot(2,2,1);
    plot(aud);
    title('Original waveform');
    xlabel('Time (samples)');

    subplot(2,2,2); cla; hold on;
    title('Windowed waveform');
    xlabel('Time (samples)');
    ylabel('Amplitude');
    

    subplot(2,2,3); cla; hold on;
    title('STFT of windowed waveform ');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (Abs)');
    legend;

    subplot(2,2,4); cla; hold on;
    xlabel('Frequency (Hz)');
    title('STFT of windowed waveform (log scale)');
    ylabel('Magnitude (dB)');
    legend;

    figure(2)
    sgtitle('Short-Time Analysis, with Rectangular Window, Variable Frame Lengths');
    subplot(2,2,1);
    plot(aud);
    title('Original waveform');
    xlabel('Time (samples)');

    subplot(2,2,2); cla; hold on;
    ylim([-1, 1.5])
    title('Windowed waveform');
    xlabel('Time (samples)');
    ylabel('Amplitude');

    subplot(2,2,3); cla; hold on;
    title('STFT of windowed waveform');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (Abs)');
    legend;

    subplot(2,2,4); cla; hold on;
    xlabel('Frequency (Hz)');
    title('STFT of windowed waveform (log scale)');
    ylabel('Magnitude (dB)');
    legend;

    

    for idx = 1:num
        framelength = framelengths(idx);

        framelength_smp = framelength * fs / 1000;

        hamm_win = hamming(framelength_smp);
        aud_hamm = aud(startsmp:startsmp+framelength_smp-1) .* hamm_win;
        rect_win = rectwin(framelength_smp);
        aud_rect = aud(startsmp:startsmp+framelength_smp-1) .* rect_win;

        nfft = 2^nextpow2(framelength_smp);
        STFT_hamm = abs(fft(aud_hamm, nfft));
        STFT_rect = abs(fft(aud_rect, nfft));

        freq = 0:fs/nfft:fs/2;

        figure(1);
        subplot(2,2,2);
        plot(hamm_win, "Color", colors(idx, :), 'DisplayName', sprintf("%d", framelength));
        hold on;
        plot(aud_hamm, "Color", colors(idx, :), 'HandleVisibility', 'off');
        legend('Location', 'best');


        subplot(2,2,3);
        plot(freq, STFT_hamm(1:nfft/2+1) ...
            , 'DisplayName', sprintf("%d", framelength));
        

        subplot(2,2,4);
        plot(freq, 20*log10(STFT_hamm(1:nfft/2+1))...
            , 'DisplayName', sprintf("%d", framelength));
        

        figure(2);
        subplot(2,2,2);
        h_win = plot(rect_win, "Color", colors(idx, :), 'DisplayName', sprintf("%d", framelength));
        hold on;
        aud_win = plot(aud_rect, "Color", colors(idx, :), 'HandleVisibility', 'off');
        legend('Location', 'best');
        uistack(h_win, 'bottom')
        uistack(aud_win, 'bottom');

        subplot(2,2,3);
        plot(freq, STFT_rect(1:nfft/2+1)...
            , 'DisplayName', sprintf("%d", framelength));


        subplot(2,2,4);
        plot(freq, 20*log10(STFT_rect(1:nfft/2+1))...
            , 'DisplayName', sprintf("%d", framelength));


    end

end