[aud, fs] = audioread("test_16k.wav");

t = ( 1:400 )' / fs;
voiced = aud(13000:13399);
unvoiced = aud(3400:3799);

hamm = hamming(400); % Hamming window of length 400
voiced = voiced .* hamm;
unvoiced = unvoiced .* hamm;

voiced_padd = [voiced; zeros(512-length(voiced), 1)];
unvoiced_padd = [unvoiced; zeros(512-length(unvoiced), 1)];

voiced_Spec = fft(voiced_padd, 512); % FFT of voiced signal
unvoiced_Spec = fft(unvoiced_padd, 512); % FFT of unvoiced signal

voiced_Spec = log(abs(voiced_Spec)); % Logarithm of the magnitude spectrum
unvoiced_Spec = log(abs(unvoiced_Spec)); % Logarithm of the magnitude spectrum

[voiced_ccep, voiced_rcep] = Cepstrum(voiced_padd, 512); % 512 is the closese 2^n to 400
[unvoiced_ccep, unvoiced_rcep] = Cepstrum(unvoiced_padd, 512); % 512 is the closese 2^n to 400

cutoff = 30; % cut-off quefrency
lifter = [ones(cutoff,1); zeros(512-cutoff,1)]; 

voiced_liftered = voiced_rcep .* lifter; % Liftered cepstrum of voiced signal
unvoiced_liftered = unvoiced_rcep .* lifter; % Liftered cepstrum of unvoiced signal

voiced_liftered_spectrum = abs(fft(voiced_liftered, 512)); % Liftered cepstrum to spectrum of voiced signal
unvoiced_liftered_spectrum = abs(fft(unvoiced_liftered, 512)); % Liftered cepstrum to spectrum of unvoiced signal

% Figure for voiced signal
figure;
subplot(2,2,1);
plot(t, voiced);
title('Voiced Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,2,2);
plot(0:(fs/2-1)/(length(voiced_Spec)/2-1):fs/2, voiced_Spec(1:length(voiced_Spec)/2));
title('Voiced Log Spectrum');
xlabel('Frequency (Hz)');
ylabel('Log Magnitude');

subplot(2,2,3);
plot(0:length(voiced_rcep)-1, voiced_rcep);
title('Voiced Real Cepstrum');
xlabel('Quefrency (samples)');
ylabel('Amplitude');

subplot(2,2,4);
plot(0:(fs/2-1)/(length(voiced_liftered_spectrum)/2-1):fs/2, voiced_liftered_spectrum(1:length(voiced_liftered_spectrum)/2));
title('Voiced Liftered Log Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Figure for unvoiced signal
figure;
subplot(2,2,1);
plot(t, unvoiced);
title('Unvoiced Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,2,2);
plot(0:(fs/2-1)/(length(unvoiced_Spec)/2-1):fs/2, unvoiced_Spec(1:length(unvoiced_Spec)/2));
title('Unvoiced Log Spectrum');
xlabel('Frequency (Hz)');
ylabel('Log Magnitude');

subplot(2,2,3);
plot(0:length(unvoiced_rcep)-1, unvoiced_rcep);
title('Unvoiced Real Cepstrum');
xlabel('Quefrency (samples)');
ylabel('Amplitude');

subplot(2,2,4);
plot(0:(fs/2-1)/(length(unvoiced_liftered_spectrum)/2-1):fs/2, unvoiced_liftered_spectrum(1:length(unvoiced_liftered_spectrum)/2));
title('Unvoiced Liftered Log Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
