filename = "s5.wav";
number_of_analysis = 4;
frame_lengths = [5 10 20 40];
starting_smp = 7000;

STSA_MultiLengths(number_of_analysis, filename, starting_smp, frame_lengths);
