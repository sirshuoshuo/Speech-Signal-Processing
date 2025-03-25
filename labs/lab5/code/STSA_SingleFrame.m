function STSA_SingleFrame(filename, startsmp, framelength)
    [aud, fs] = audioread(filename);

    % The original framelength is in ms, convert it to samples
    framelength = framelength * fs / 1000;

    win = hamming(framelength);

    aud_win = aud(startsmp:startsmp+framelength-1) .* win;

    nfft = 2^nextpow2(framelength);
    STFT_win = abs(fft(aud_win, nfft));

    freq = 0:fs/nfft:fs/2;

    figure
    subplot(2,2,1)
    plot(aud);
    title('Original waveform');
    xlabel('Time (samples)');
    ylabel('Amplitude');

    subplot(2,2,2)
    plot(aud_win);
    title('Windowed waveform');
    xlabel('Time (samples)');
    ylabel('Amplitude');

    subplot(2,2,3)
    plot(freq, STFT_win(1:nfft/2+1));
    title('STFT of windowed waveform');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');

    subplot(2,2,4)
    plot(freq, 20*log10(STFT_win(1:nfft/2+1)));
    title('STFT of windowed waveform (log scale)');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude(dB)');














end