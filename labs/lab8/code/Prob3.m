[y, fs] = audioread('s6.wav');
figure
plot(y)
gender = 1;
[pitch_period, confidence] = PitchDetector_Cepstrum(y, fs, gender);
% pitch = 1./pitch_period

figure
subplot(211), plot(pitch_period), ylabel('Pitch-Period'), xlabel('frame-number')
subplot(212), plot(confidence), ylabel('Condifence'), xlabel('frame-number')