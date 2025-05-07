xin = -1:0.001:1;

X_round = fxquant(xin, 4, 'round', 'sat');
X_trunc = fxquant(xin, 4, 'trunc', 'sat');

e_round_abs = abs(X_round - xin);
e_trunc_abs = abs(X_trunc - xin);

e_round = X_round - xin;
e_trunc = X_trunc - xin;

% Find the range of quantization errors
max_e_round = max(e_round);
min_e_round = min(e_round);
max_e_trunc = max(e_trunc);
min_e_trunc = min(e_trunc);

fprintf('Rounding error range: [%f, %f]\n', min_e_round, max_e_round);
fprintf('Truncation error range: [%f, %f]\n', min_e_trunc, max_e_trunc);

% First figure: Quantization input-output
figure;
subplot(2,1,1);
plot(xin, X_round, 'b-', 'LineWidth', 1.5);
title('Rounding Quantization');
xlabel('Input'); ylabel('Output');
grid on;

subplot(2,1,2);
plot(xin, X_trunc, 'r-', 'LineWidth', 1.5);
title('Truncation Quantization');
xlabel('Input'); ylabel('Output');
grid on;

% Second figure: Quantization errors
figure;
subplot(2,1,1);
plot(xin, e_round, 'b-', 'LineWidth', 1.5);
title('Rounding Quantization Error');
xlabel('Input'); ylabel('Absolute Error');
grid on;

subplot(2,1,2);
plot(xin, e_trunc, 'r-', 'LineWidth', 1.5);
title('Truncation Quantization Error');
xlabel('Input'); ylabel('Absolute Error');
grid on;

%%

[aud, fs] = audioread('s5.wav');

aud = aud(1300:18800);

aud_quant_10bits = fxquant(aud, 10, 'round', 'sat');
aud_quant_8bits = fxquant(aud, 8, 'round', 'sat');
aud_quant_4bits = fxquant(aud, 4, 'round', 'sat');

err_quant_10bits = aud_quant_10bits - aud;
err_quant_8bits = aud_quant_8bits - aud;
err_quant_4bits = aud_quant_4bits - aud;

% Plot the error sequences using strips
figure;
subplot(3,1,1);
strips(err_quant_10bits(1:8000), 2000);
title('10-bit Quantization Error');
ylabel('Error');
grid on;

subplot(3,1,2);
strips(err_quant_8bits(1:8000), 2000);
title('8-bit Quantization Error');
ylabel('Error');
grid on;

subplot(3,1,3);
strips(err_quant_4bits(1:8000), 2000);
title('4-bit Quantization Error');
ylabel('Error');
grid on;

%%

figure
subplot(3,1,1);
histogram(err_quant_10bits, 50);
title('10-bit Quantization Error Histogram');
xlabel('Error Value'); ylabel('Frequency');
grid on;

subplot(3,1,2);
histogram(err_quant_8bits, 50);
title('8-bit Quantization Error Histogram');
xlabel('Error Value'); ylabel('Frequency');
grid on;

subplot(3,1,3);
histogram(err_quant_4bits, 50);
title('4-bit Quantization Error Histogram');
xlabel('Error Value'); ylabel('Frequency');
grid on;

%%

[err_pxx_10bits, f] = pspectrum(err_quant_10bits);
[err_pxx_8bits, f] = pspectrum(err_quant_8bits);
[err_pxx_4bits, f] = pspectrum(err_quant_4bits);

figure;
subplot(3,1,1);
plot(f, 10*log10(err_pxx_10bits));
title('10-bit Quantization Error Power Spectrum');
xlabel('Frequency (Hz)'); ylabel('Power/Frequency (dB/Hz)');
grid on;

subplot(3,1,2);
plot(f, 10*log10(err_pxx_8bits));
title('8-bit Quantization Error Power Spectrum');
xlabel('Frequency (Hz)'); ylabel('Power/Frequency (dB/Hz)');
grid on;

subplot(3,1,3);
plot(f, 10*log10(err_pxx_4bits));
title('4-bit Quantization Error Power Spectrum');
xlabel('Frequency (Hz)'); ylabel('Power/Frequency (dB/Hz)');
grid on;

mean_power_db_10bits = mean(10*log10(err_pxx_10bits));
mean_power_db_8bits = mean(10*log10(err_pxx_8bits));

fprintf('Mean Power in dB for 10-bit: %f\n', mean_power_db_10bits);
fprintf('Mean Power in dB for 8-bit: %f\n', mean_power_db_8bits);