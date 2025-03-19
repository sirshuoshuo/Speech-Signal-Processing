[aud, fs] = audioread('s5.wav');
L = 257;
R = 128;

win = rectwin(L);
win_hanning = hann(L);
win_hamming = hamming(L);
[waveform, energy, magnitude, zero_crossing, time] = STA(aud, fs, R, win);
[waveform_hanning, energy_hanning, magnitude_hanning, zero_crossing_hanning, time_hanning] = STA(aud, fs, R, win_hanning);
[waveform_hamming, energy_hamming, magnitude_hamming, zero_crossing_hamming, time_hamming] = STA(aud, fs, R, win_hamming);

figure;
sgtitle('Short-Time Analysis, with Rectangular Window, L=257, R=128');
subplot(4,1,1);
plot(waveform);
title('Waveform');
xlabel('Time (samples)');
ylabel('Amplitude');

subplot(4,1,2);
plot(time, energy);
title('Short-Time Energy');
xlabel('Frame');
ylabel('Energy');

subplot(4,1,3);
plot(time, magnitude);
title('Short-Time Magnitude');
xlabel('Frame');
ylabel('Magnitude');

subplot(4,1,4);
plot(time, zero_crossing);
title('Zero Crossing Rate');
xlabel('Frame');
ylabel('Rate');

figure;
sgtitle('Short-Time Analysis, with Hanning Window, L=257, R=128');
subplot(4,1,1);
plot(waveform_hanning);
title('Waveform');
xlabel('Time (samples)');
ylabel('Amplitude');

subplot(4,1,2);
plot(time_hanning, energy_hanning);
title('Short-Time Energy');
xlabel('Frame');
ylabel('Energy');

subplot(4,1,3);
plot(time_hanning, magnitude_hanning);
title('Short-Time Magnitude');
xlabel('Frame');
ylabel('Magnitude');

subplot(4,1,4);
plot(time_hanning, zero_crossing_hanning);
title('Zero Crossing Rate');
xlabel('Frame');
ylabel('Rate');

figure;
sgtitle('Short-Time Analysis, with Hamming Window, L=257, R=128');
subplot(4,1,1);
plot(waveform_hamming);
title('Waveform');
xlabel('Time (samples)');
ylabel('Amplitude');

subplot(4,1,2);
plot(time_hamming, energy_hamming);
title('Short-Time Energy');
xlabel('Frame');
ylabel('Energy');

subplot(4,1,3);
plot(time_hamming, magnitude_hamming);
title('Short-Time Magnitude');
xlabel('Frame');
ylabel('Magnitude');

subplot(4,1,4);
plot(time_hamming, zero_crossing_hamming);
title('Zero Crossing Rate');
xlabel('Frame');
ylabel('Rate');