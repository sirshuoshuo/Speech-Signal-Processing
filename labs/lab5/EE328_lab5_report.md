# **Lab5 Report**
### *李梓源     SID:12211225*
### *李沅朔     SID:12210301*

---
## Introduction
In this lab course, we mainly focus on the **short-time spectral analysis ** of speech signal. This approach generally includes **separating audio signal into short-time frames**, and **do spectral analysis based on frames instead on the waveform**. This approach addresses the problem that speech signal is **intrinsically time-variant**, therefore doing spectral analysis on the whole waveform would discard the information included in the audio's time-spectral characteristics. 

Tasks included in this lab assignment will cover analysing **single frame's spectrum**, the effect of **window length** on such analysis, and creating **spectrogram** based on short-time spectral analysis. 

---

## Problem 1
- **Problem description:**

Write a MATLAB program to perform short-time spectral analysis on a single frame of the given speech waveform. The program should accept the speech, the starting sample, and the frame length in ms, and plot the original waveform, the windowed waveform, the magnitude of the STFT, both in absolute value and in dB scale. 

- **Solutions and process**

1. As suggested by the slides, we desined a function `STSA_SingleFrame(filename, startsmp, framelength)` to plot all four subplots in one figure. 

2. It should read the audio file, convert the frame length from ms to samples, do fft after being zero-padded, and display the corresponding plots.

   

- **Key code segment:**

*1.* First the audio is read into the function, and the frame length is converted into the the desired unit. The audio is then separeated by the coverted index numbers.

```matlab
	[aud, fs] = audioread(filename);

    % The original framelength is in ms, convert it to samples
    framelength = framelength * fs / 1000;

    win = hamming(framelength);

    aud_win = aud(startsmp:startsmp+framelength-1) .* win;
```

*2.* FFT is called with zero padding the length to the closest exponential value of 2. The corresponding physical frequency of the fft result is the calculated.

```matlab
    nfft = 2^nextpow2(framelength);
    STFT_win = abs(fft(aud_win, nfft));

    freq = 0:fs/nfft:fs/2;
    
```

3. Then the plots are draw in one figure. The function is called to process the assigned speech signals with the given parameters.

   ```matlab
   figure
       subplot(2,2,1)
       plot(aud);
       title('Original waveform');
       xlabel('Time (samples)');
       ylabel('Amplitude');
   ...
   
   % 第一个信号应该在7000处开始，s5.wav
   
   STSA_SingleFrame("s5.wav", 7000, 40);
   
   % 第二个信号从10000开始，vowel_iy_100hz.wav
   
   STSA_SingleFrame("vowel_iy_100hz.wav", 1000, 40);
   ```

   

- **Result and Analysis:**

    + Plots for s5.wav
      ![image-20250325151138643](./assets/image-20250325151138643.png)

    + plots for vowel_iy_100hz.wav

        ![image-20250325151105488](./assets/image-20250325151105488.png)

        The function `STSA_SingleFrame` successfully analyses the spectrum of one frame in the given waveform, and draws the STFT results of them. 

---

## Problem 2
- **Problem description:** 

  In this problem, we are required to write a program to perform and compare the results of multiple short-time analyses. In this problem, the effects of different window types  (Hamming, Rectangular) and window length (5, 10, 20, 40, in ms ) are discussed. 



- **Solution and process**:

1. This task requires us to plot different data lines on the same graph, so we would first initialize two figures and reuse them for the drawing later. Also we draw the constant elements, including the original waveform and the labels. 
2. The main procedure will be largely the same as problem 1. We segment the original waveform, do STFT analysis, draw corresponding plots, and add legend to each subplot. 
3. In the outer script, we call the function to draw the plots. 


- **Key code segment:**

>1. We first read the audio and initiate all figures. Also, original waveform, which should be drawn only once, is also covered in this part. 
>
>   ```matlab
>   [aud, fs] = audioread(filename);
>   
>       colors = lines(num);
>   
>       figure(1)
>       sgtitle('Short-Time Analysis, with Hamming Window, Variable Frame Lengths');
>       subplot(2,2,1);
>       plot(aud);
>       title('Original waveform');
>       xlabel('Time (samples)');
>   	...
>   ```
>
>2. Then in a for loop dependent of the parameter `num`, we calculate the STFTs of the signals with corresponding lengths as stored in the `framelengths` vector.
>
>   ```matlab
>   for idx = 1:num
>           framelength = framelengths(idx);
>   
>           framelength_smp = framelength * fs / 1000;
>   
>           hamm_win = hamming(framelength_smp);
>           aud_hamm = aud(startsmp:startsmp+framelength_smp-1) .* hamm_win;
>           rect_win = rectwin(framelength_smp);
>           aud_rect = aud(startsmp:startsmp+framelength_smp-1) .* rect_win;
>   
>           nfft = 2^nextpow2(framelength_smp);
>           STFT_hamm = abs(fft(aud_hamm, nfft));
>           STFT_rect = abs(fft(aud_rect, nfft));
>   
>           freq = 0:fs/nfft:fs/2;
>   ```
>
>3. Then we plot the overlapping figures.
>
>   ```matlab
>           figure(1);
>           subplot(2,2,2);
>           plot(hamm_win, "Color", colors(idx, :), 'DisplayName', sprintf("%d", framelength));
>           hold on;
>           plot(aud_hamm, "Color", colors(idx, :), 'HandleVisibility', 'off');
>           legend('Location', 'best');
>   
>   
>           subplot(2,2,3);
>           plot(freq, STFT_hamm(1:nfft/2+1) ...
>               , 'DisplayName', sprintf("%d", framelength));
>   ```
>
>   Note that for audio lines that do not need a legend, we should turn the `'HandleVisibility'` property off. 


- **Result and Analysis:**

    <img src="./assets/image-20250325170240998.png" alt="image-20250325170240998" style="zoom:50%;" />

    <img src="./assets/image-20250325170320567.png" alt="image-20250325170320567" style="zoom:50%;" />

-  Observations

    - **Window Length:** windows with larger length have better frequency solution. However, it will sacrifice temporal solution because more samples are required for longer windows.
    - **Window Type:** spectrum processed with rectangular window is more "spiky". It indicates a better resolution, however also show that the processed signal suffers from high-frequency noise retained or introduced by side-lobe leakage. Conversely, Hamming window introduces less sidelobe leakage, sacrificing resolution.

    


---
## Problem 3
- **Problem description:**

We are required to show the effects of window duration on the short-time analysis of energy, magnitude, and zero crossings. Specifically, we will use frame lengths of 51, 101, 201, 401 samples, and use a rectangular window. We will continue to utilize the `STA` function we wrote in problem 2.


- **Key code segment:**


```matlab
L = [51, 101, 201, 401];
[aud, fs] = audioread('test_16k.wav');

energy_results = cell(1, length(L));
magnitude_results = cell(1, length(L));
zero_crossing_results = cell(1, length(L));
time_results = cell(1, length(L));
```

 We store corresponding results in cell arrays. The characteristics of cell arrays enable us to store vectors with different sizes together. 

```matlab
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
```

For each L number, we call the STA function and store its return values into corresponding positions of the cell arrays.


- **Result and Aanalysis:**

![image-20250319231517754](./assets/image-20250319231517754.png)

1. The **shape of curves are consistent** throughout the changes of L. 
2. As shown in the magnitude and the energy plots, windows with **greater length** tend to have **bigger values** because they naturally include more signals. 
3. However windows with greater lengths **act like low-pass filters** and will lose high-frequency changes when compared with windows with smaller sizes.
4. In the ZC plot, because the calculating method takes average values across each window, **the magnitude of different curves remain consistent.** Also we can observe that **windows with greater length filters out high-frequency changes**, while windows with shorter lengths retain them. 

---

## Conclusion

Short-time spectrum analysis is an important approach used to analyse speech signals. The general methodology is segmenting original signal into frames, and do short-time fourier transform on those frames. It can effectively capture the information included in the chonologic patterns of a speech signal. 

Different aspects can affect the analysis. In this assignment, we discussed two main elements: the window length and the window type. To summarize in one sentence, every selection is a tradeoff. 

- window size: If you want to have better temporal solution, you would sacrifice spectral solution for it. 
- window type: If you want better resolution, you would sacrifice worse sidelobe leaks values for it. 



