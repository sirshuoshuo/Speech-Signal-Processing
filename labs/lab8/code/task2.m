[aud, fs] = audioread("test_16k.wav");

[pitch, conf, unfilt_pitch, unfilt_conf] = PitchDetector_Autocorrelation(aud, fs, 1);

figure 
subplot(2,1,1)
plot(pitch)
title("Estimated pitch")

subplot(2,1,2)
plot(conf)
title("Confidence")


figure 
subplot(2,1,1)
plot(unfilt_pitch)
title("Unfiltered estimated pitch")

subplot(2,1,2)
plot(unfilt_conf)
title("Unfiltered confidence")

%%



pitch_smoothed = MedianSmoother(pitch, 5);
conf_smoothed = MedianSmoother(conf, 5);

unfilt_pitch_smoothed = MedianSmoother(unfilt_pitch, 5);
unfilt_conf_smoothed = MedianSmoother(unfilt_conf, 5);

figure 
subplot(2,1,1)
plot(pitch_smoothed)
title("Smoothed pitch")

subplot(2,1,2)
plot(conf_smoothed)
title("Smoothed confidence")

figure 
subplot(2,1,1)
plot(unfilt_pitch_smoothed)
title("Smoothed unfiltered pitch")

subplot(2,1,2)
plot(unfilt_conf_smoothed)
title("Smoothed unfiltered confidence")


%%

save("out_autoc.mat", "pitch_smoothed", "conf_smoothed");
