[aud, fs] = audioread("test_16k.wav");

frame_sample_num = 10e-3 * fs;
frame_shift_num = 5e-3 * fs;

rect_win = rectwin(frame_sample_num);

[waveform, zero_crossing_vector, time_axis] = ZCA(aud, fs, frame_shift_num, rect_win);

figure 

plot(time_axis, zero_crossing_vector)

%%


load("Filt_task1.mat");

zero_crossing_lin = filter(Filt_task1, 1, zero_crossing_vector);

figure 

plot(time_axis, zero_crossing_lin);

%%

L_filt = 7;

zero_crossing_med = MedianSmoother(zero_crossing_vector, L_filt);

figure 
plot(time_axis, zero_crossing_med);


%%
% Combinational Filter

t1 = MedianSmoother(zero_crossing_vector, L_filt);
t1 = filter(Filt_task1, 1, t1);
t0 = [zeros(1, (L_filt-1)/2), zero_crossing_vector];
t0 = t0(1:length(zero_crossing_vector));

t2 = t0 - t1;
t3 = [zeros(1, (L_filt-1)/2), t1];
t3 = t3(1:length(zero_crossing_vector));

t4 = MedianSmoother(t2, L_filt);
t4 = filter(Filt_task1, 1, t4);

y_comb = t3+t4;

figure
plot(time_axis, y_comb);

%%

figure

subplot(2,2,1)
plot(time_axis, zero_crossing_vector)
title('Original Zero Crossing Rate')
xlabel('Time (s)')
ylabel('Zero Crossing Rate')

subplot(2,2,2)
plot(time_axis, zero_crossing_lin)
title('Linear Filtered Zero Crossing Rate')
xlabel('Time (s)')
ylabel('Zero Crossing Rate')

subplot(2,2,3)
plot(time_axis, zero_crossing_med)
title('Median Filtered Zero Crossing Rate')
xlabel('Time (s)')
ylabel('Zero Crossing Rate')

subplot(2,2,4)
plot(time_axis, y_comb)
title('Combined Filtered Zero Crossing Rate')
xlabel('Time (s)')
ylabel('Zero Crossing Rate')












