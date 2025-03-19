L = [51, 101, 201, 401];
[aud, fs] = audioread('test_16k.wav');

energy_results = cell(1, length(L));
magnitude_results = cell(1, length(L));
zero_crossing_results = cell(1, length(L));
time_results = cell(1, length(L));


for i = 1:length(L)
    L_i = L(i);
    R = floor(L_i / 2); % to make sure R is an integer
    win = rectwin(L_i);
    [waveform, energy, magnitude, zero_crossing, time] = STA(aud, fs, R, win);

    energy_results{i} = energy;
    magnitude_results{i} = magnitude;
    zero_crossing_results{i} = zero_crossing;
    time_results{i} = time;    
end

figure
sgtitle('Short-Time Analysis, with Rectangular Window, R=L/2, Variable L size');
subplot(2,2,1);
plot(waveform);
title('Original Waveform');
xlabel('Time (samples)');

subplot(2,2,2);
for i = 1:length(L)
    plot(time_results{i}, energy_results{i}), hold on
end
hold off
title('Short-Time Energy');
xlabel('time (s)');
ylabel('Energy');
legend('L=51', 'L=101', 'L=201', 'L=401');

subplot(2,2,3);
for i = 1:length(L)
    plot(time_results{i}, magnitude_results{i}), hold on
end
hold off
title('Short-Time Magnitude');
xlabel('time (s)');
ylabel('Magnitude');
legend('L=51', 'L=101', 'L=201', 'L=401');

subplot(2,2,4);
for i = 1:length(L)
    plot(time_results{i}, zero_crossing_results{i}), hold on
end
hold off
title('Short-Time Zero Crossing Rate');
xlabel('time (s)');
ylabel('Zero Crossing Rate');
legend('L=51', 'L=101', 'L=201', 'L=401');
