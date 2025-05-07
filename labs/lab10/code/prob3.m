alpha_1 = 0.9;
alpha_2 = 0.99;

b_1 = [0 (1-alpha_1)];
b_2 = [0 (1-alpha_2)];
a_1 = [1 -alpha_1];
a_2 = [1 -alpha_2];

[aud, fs] = audioread('s5.wav');
aud = aud - mean(aud);
aud_squared = aud.^2;

delta_1 = sqrt(filter(b_1, a_1, aud_squared));
delta_2 = sqrt(filter(b_2, a_2, aud_squared));

gain_equalized_1 = aud ./ delta_1;
gain_equalized_2 = aud ./ delta_2;

figure(1)
subplot(2,1,1);
plot(aud_squared(2700:6700)); hold on;
plot(delta_1(2700:6700), 'r'); hold off;
title('S5 Squared Signal and Delta 1');
xlabel('Sample Number'); ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(gain_equalized_1(2700:6700));
title('S5 Gain Equalized Signal 1');
xlabel('Sample Number'); ylabel('Amplitude');
grid on;



figure(2)
subplot(2,1,1);
plot(aud_squared(2700:6700)); hold on;
plot(delta_2(2700:6700), 'r'); hold off;
title('S5 Squared Signal and Delta 2');
xlabel('Sample Number'); ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(gain_equalized_2(2700:6700));
title('S5 Gain Equalized Signal 2');
xlabel('Sample Number'); ylabel('Amplitude');
grid on;


figure(3)
plot(aud(2700:6700));
title('S5 Original Signal');
xlabel('Sample Number'); ylabel('Amplitude');

%%

M_1 = 10;
M_2 = 100;

b_fir_1 = ones(1, M_1) / M_1;
b_fir_2 = ones(1, M_2) / M_2;

delta_fir_1 = sqrt(filter(b_fir_1, 1, aud_squared));
delta_fir_2 = sqrt(filter(b_fir_2, 1, aud_squared));

gain_equalized_fir_1 = aud ./ delta_fir_1;
gain_equalized_fir_2 = aud ./ delta_fir_2;

figure(4)
subplot(2,1,1);
plot(aud_squared(2700:6700)); hold on;
plot(delta_fir_1(2700:6700), 'r'); hold off;
title('S5 Squared Signal and FIR Delta 1');
xlabel('Sample Number'); ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(gain_equalized_fir_1(2700:6700));
title('S5 Gain Equalized FIR Signal 1');
xlabel('Sample Number'); ylabel('Amplitude');
grid on;

figure(5)
subplot(2,1,1);
plot(aud_squared(2700:6700)); hold on;
plot(delta_fir_2(2700:6700), 'r'); hold off;
title('S5 Squared Signal and FIR Delta 2');
xlabel('Sample Number'); ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(gain_equalized_fir_2(2700:6700));
title('S5 Gain Equalized FIR Signal 2');
xlabel('Sample Number'); ylabel('Amplitude');
grid on;


