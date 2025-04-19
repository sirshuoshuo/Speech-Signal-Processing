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
