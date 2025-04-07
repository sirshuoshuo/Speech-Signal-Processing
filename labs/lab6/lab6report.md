# **Lab5 Report**
### *李梓源     SID:12211225*
### *李沅朔     SID:12210301*

---
## Introduction
In this lab course, we learned a new method to analysis signals called cepstrum. Intuitively, cepstrum is the *frequency response of the frequency domain*, which is used to saparate two signals doing convolution. This method will be used further in speech siganl processing and analysis, and in this lab problems are designed for us to understand its basic principles and test it on several expample siganls. 

---

## Problem 1
- **Problem description:**

Write a MATLAB program(function) to compute the real and complex cepstrum of a given siganl $x[n] = \delta[x] + 0.85\delta[x-100]$. Notably, no MATLAB functions like `cceps()` or `rceps` should be used in the code. At last, plot all three figures.

- **Solutions and process**

1. Understanding Cepstrum

Cepstrum is used to deconvlute siganls. For example, voice is sound from the vocal track, which can be viewed as a concolution of the vocal channel and the voice siganl, and cepstrum can help to deconcolute these two. The method can be ilusstarted by the following diagram:
![image-20250325151138643](./assets/cep_principle.png)

`fft()` in step1 is to convert convolution to multiply. And take the logarithm in step2 is to convert multiply in step1 to addition. And finally use `ifft()` to finish the cepstrum analysis.

2. Real cepstrum and complex cepstrum

For real cepstrum, we only take the real part of the magnitude response. But in the complex cepstrum, we need to add the complex part(phase information) of the signal. Notably,phase in `fft()` is incontinuity, so we need to unwrap the signal phase inorder to do the complex cepstrum.
![image-20250325151138643](./assets/unwrap.png)

   

- **Key code segment:**

The code follows the ideas mentioned above and is devided into real_cep calculation and complex_cep calculation
```matlab
n = 0:100;
y = (n==0) + 0.85*(n-100==0);
N = length(y);

nfft = N;
[cY, rY] = Cepstrum(y, nfft);
quefrency_c = (0:length(cY)-1)/fs;
quefrency_r = (0:length(rY)-1)/fs;

figure
subplot(311)
stem(0:length(y)-1, y)
title('origin signal'), xlabel('samples')

subplot(312)
stem(0:length(rY)-1, rY), xlabel('Quefrency'), title('rael cepstrum')


subplot(313)
stem(0:length(cY)-1, cY), xlabel('Quefrency'), title('complex cepstrum')

function [ccepstrum, rcepstrum] = Cepstrum(y, nfft)
    % real cepstrum
    Y = fft(y, nfft);
    Y_log = log(abs(Y));
    rcepstrum  =ifft(Y_log, 'symmetric');
        
    %complex cepstrum
    phase = unwrap(angle(Y));
    ccepstrum = log(abs(Y)) + 1j * unwrap(angle(Y));   % 相位展开
    ccepstrum = real(ifft(ccepstrum));
end
```
  

- **Result and Analysis:**

![P1](./assets/P1.png)
As we can see in the result, the real cepstrum is symmetry and its x-axis have the same unit as the origin signal. Also, at the begining and the end of the signal, the siganl's frqeuency response shows more periodicity.

---

## Problem 2
- **Problem description:** 

  In this problem, we are required to write a program to perform and compare the results of multiple cepstrum. A new signal $\alpha^nu[n]$ is given and we need to test different parameters and verify its effects. 


- **Solution and process**:

1. Same as problem1, we need to calculate both the real and the complex cepstrum of the given siganl.

2. Change the parameters and compare the results.


- **Key code segment:**

>1. We first define differnet parameters and then input the parameters in the function to do the follow up calculation.

```matlab
clc, clear
% parameters, change for different cases
a = 0.9;   % 0.5, 0.9
N = 200;   % 10, 200
nfft = 256;   % 10, 16, 200, 256
n = 0:N-1;
y = a.^n .* (n>=0);
% real cepstrum
Y = fft(y, nfft);
Y_log = log(abs(Y));
Y_cep = ifft(Y_log);

figure;
stem(0:length(Y_cep)-1, Y_cep), title('a=0.9, N=200, nfft=256'), xlabel('samples')
saveas(gcf, "D:/作业提交/大三 下/语音信号处理/lab6/P2_16_r.png", 'png')

% complex cepstrum
phase = unwrap(angle(Y));
Y_ccep = Y_log + 1i*phase;
Y_ccep = ifft(Y_ccep);
figure
stem(0:length(Y_ccep)-1, Y_ccep), title('a=0.5, N=200, nfft=256'), xlabel('samples')
saveas(gcf, "D:/作业提交/大三 下/语音信号处理/lab6/P2_16_c.png", 'png')
```


- **Result and Analysis:**
  + Real ceptsrum
    <div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
  <img src="./assets/P2_1_r.png" style="width: 23%;">
  <img src="./assets/P2_2_r.png" style="width: 23%;">
  <img src="./assets/P2_3_r.png" style="width: 23%;">
  <img src="./assets/P2_4_r.png" style="width: 23%;">
  <img src="./assets/P2_5_r.png" style="width: 23%;">
  <img src="./assets/P2_6_r.png" style="width: 23%;">
  <img src="./assets/P2_7_r.png" style="width: 23%;">
  <img src="./assets/P2_8_r.png" style="width: 23%;">
  <img src="./assets/P2_9_r.png" style="width: 23%;">
  <img src="./assets/P2_10_r.png" style="width: 23%;">
  <img src="./assets/P2_11_r.png" style="width: 23%;">
  <img src="./assets/P2_12_r.png" style="width: 23%;">
  <img src="./assets/P2_13_r.png" style="width: 23%;">
  <img src="./assets/P2_14_r.png" style="width: 23%;">
  <img src="./assets/P2_15_r.png" style="width: 23%;">
  <img src="./assets/P2_16_r.png" style="width: 23%;">
</div>

  + Complex cepstrum
      <div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
    <img src="./assets/P2_1_c.png" style="width: 23%;">
    <img src="./assets/P2_2_c.png" style="width: 23%;">
    <img src="./assets/P2_3_c.png" style="width: 23%;">
    <img src="./assets/P2_4_c.png" style="width: 23%;">
    <img src="./assets/P2_5_c.png" style="width: 23%;">
    <img src="./assets/P2_6_c.png" style="width: 23%;">
    <img src="./assets/P2_7_c.png" style="width: 23%;">
    <img src="./assets/P2_8_c.png" style="width: 23%;">
    <img src="./assets/P2_9_c.png" style="width: 23%;">
    <img src="./assets/P2_10_c.png" style="width: 23%;">
    <img src="./assets/P2_11_c.png" style="width: 23%;">
    <img src="./assets/P2_12_c.png" style="width: 23%;">
    <img src="./assets/P2_13_c.png" style="width: 23%;">
    <img src="./assets/P2_14_c.png" style="width: 23%;">
    <img src="./assets/P2_15_c.png" style="width: 23%;">
    <img src="./assets/P2_16_c.png" style="width: 23%;">
  </div>

-  Observations

    - **N:** N is the length of the given siganl, when the signal length grow longer, a larger nfft is required theoretically.
    - **nfft:** the number of `fft()` specifies the accuracy of the cepstrum. when nfft is larger than N, the quefrency performs much more precise. However, when nfft is smaller than N, the signal is truncated and shows less details.
    - **a:** The parameter a directly change the expression of the signal, and as we can see the difference clearly in the result.

    
---
## Problem 3
- **Problem description:**
Despite using `fft` to process a frame of audio, it's also important to understand the differences between wideband and narrowband spectrum. In the part, a function is required to plot the wideband and narrowaband spectrum in different given parameters. By comparing its differences, more details of the audio signal can be revealed.

- **Key code segment:**

> We  first do some regular process, including reading the audio file and resampling it.
```matlab
% read file
[y, fs] = audioread(filename);

% resample;=[l[llpp[p]]]
if resamplerate ~= 0
    y_new = resample(y, resamplerate, fs);
    fs = resamplerate;
else
    y_new = y;
end
```

> Then in wideband analysis, several parameters are set and the spectrogram is calculated. Notablly, we set the dynamic range of the color map and a different choices for plotting colored map, gray map or both.
```matlab
% wideband spectrogram
Lwide = windowlengths(1) * fs * 1e-3;   % window length
FFTwide = FFTlengths(1) * fs * 1e-3;   % FFT length
win_wide = hamming(Lwide);
nfft = FFTwide;
noverlap = 0.5 * Lwide;   % window shift
[s_wide, w_wide, t_wide] = spectrogram(y_new, win_wide, noverlap,nfft, fs);
% log or linear
if magscale == "linear"
    W = abs(s_wide);
else
    W = mag2db(abs(s_wide));
end
% dynamic range
min_color = -100
max_color = max(W(:))
k = -(range+min_color-max_color)./2
min_new = min_color+k
max_new = max_color-k

% plot
if color == 1
    figure;
    imagesc(t_wide, w_wide, W);
    set(gca, 'YDir', 'normal');
    colorbar;
    caxis([min_new, max_new]);
    axis xy;
    xlabel('time'), ylabel('frequency')
    title(sprintf('wideband, window Length = %d', Lwide));
    colormap('gray')
    
elseif color == 2
    figure;
    imagesc(t_wide, w_wide, W);
    set(gca, 'YDir', 'normal');
    colorbar;
    caxis([min_new, max_new]);
    axis xy;
    xlabel('time'), ylabel('frequency')
    title(sprintf('wideband, window Length = %d', Lwide));
    colormap('parula')
    
else 
    figure;
    imagesc(t_wide, w_wide, W);
    set(gca, 'YDir', 'normal');
    colorbar;
    caxis([min_new, max_new]);
    axis xy;
    xlabel('time'), ylabel('frequency')
    title(sprintf('wideband, window Length = %d', Lwide));
    colormap('gray');
    
    figure;
    imagesc(t_wide, w_wide, W);
    set(gca, 'YDir', 'normal');
    colorbar;
    caxis([min_new, max_new]);
    axis xy;
    xlabel('time'), ylabel('frequency')
    title(sprintf('wideband, window Length = %d', Lwide));
    colormap('parula')
end
```

 > The same goes for narrowband analysis, where we set different parameters and plot the spectrogram., only to change the window length and FFTlength if needed.

```matlab
% narrowband spectrogram
Lnarrow = windowlengths(2) * fs * 1e-3;
FFTnarrow = FFTlengths(2);
win_narrow = hamming(Lnarrow);
nfft_narrow = FFTnarrow;
noverlap_narrow = 0.5 * Lnarrow;   % window shift
[s_narrow, w_narrow, t_narrow] = spectrogram(y_new, win_narrow,noverlap_narrow, nfft_narrow, fs);
% log or linear
if magscale == "linear"
    W = abs(s_narrow);
else
    W = mag2db(abs(s_narrow));
end
% dynamic range
min_color = -100;
max_color = max(W(:)) 
k = -(range+min_color-max_color)./2
min_new = min_color+k
max_new = max_color-k
% plot
if color == 1
    figure;
    imagesc(t_narrow, w_narrow, W);
    set(gca, 'YDir', 'normal');
    colorbar;
    caxis([min_new, max_new]);
    axis xy;
    xlabel('time'), ylabel('frequency')
    title(sprintf('narrowband, window Length = %d', Lnarrow));
    colormap('gray')
    
elseif color == 2
    figure;
    imagesc(t_narrow, w_narrow, W);
    set(gca, 'YDir', 'normal');
    colorbar;
    caxis([min_new, max_new]);
    axis xy;
    xlabel('time'), ylabel('frequency')
    title(sprintf('narrowband, window Length = %d', Lnarrow));
    colormap('parula')
    
else 
    figure;
    imagesc(t_narrow, w_narrow, W);
    set(gca, 'YDir', 'normal');
    colorbar;
    caxis([min_new, max_new]);
    axis xy;
    xlabel('time'), ylabel('frequency')
    title(sprintf('narrowband, window Length = %d', Lnarrow));
    colormap('gray');
    
    figure
    figure;
    imagesc(t_narrow, w_narrow, W);
    set(gca, 'YDir', 'normal');
    colorbar;
    caxis([min_new, max_new]);
    axis xy;
    xlabel('time'), ylabel('frequency')
    title(sprintf('narrowband, window Length = %d', Lnarrow));
    colormap('parula')
end  
```
note: parameter `color`:1 for gray; 2 for color; 3 for both


- **Result and Aanalysis:**

> Test for given parameters in the pdf
<table>
  <tr>
    <td><img src="./assets/P3-1-1.png" alt="origin"></td>
    <td><img src="./assets/P3-1-2.png" alt="origin"></td>
  </tr>
  <tr>
    <td><img src="./assets/P3-1-3.png" alt="origin"></td>
    <td><img src="./assets/P3-1-4.png" alt="origin"></td>
  </tr>
</table>

> Test for resampling rate changes(use wideband as default)

<div style="display: flex; gap: 10px;">
  <img src="./assets/P3-2-1.png" alt="origin" style="width: 33%;">
  <img src="./assets/P3-2-2.png" alt="origin" style="width: 33%;">
  <img src="./assets/P3-2-3.png" alt="origin" style="width: 33%;">
</div>


> Test for window length changes(use wideband as default)
<div style="display: flex; gap: 10px;">
  <img src="./assets/P3-3-1.png" alt="图1" style="width: 33.33%;">
  <img src="./assets/P3-3-2.png" alt="图2" style="width: 33.33%;">
  <img src="./assets/P3-3-3.png" alt="图3" style="width: 33.33%;">
</div>


> Test for nfft changes(use wideband as default)
<div style="display: flex; gap: 10px;">
  <img src="./assets/P3-4-1.png" alt="图片1" style="width: 50%;">
  <img src="./assets/P3-4-2.png" alt="图片2" style="width: 50%;">
</div>


> Test for "linear" plot(others are log plot by default)
<div style="display: flex; gap: 10px;">
  <img src="./assets/P3-5-1.png" alt="图片1" style="width: 50%;">
  <img src="./assets/P3-5-2.png" alt="图片2" style="width: 50%;">
</div>

1. Wideband and narrowband analysis: wideabnd and narrowband represents the length of window in time domain. A longer window means a lower resolution ratio in time domain and a higher resolution ratio in freq. domian. This explains why in *narrowband plot*, the spectrum is vertical overall and in *wideband plot* the spectrum is horizontal overall.  
2. Resampling rate analysis: the resampling rate affects the window length directly(more or less points in each frame), causing the same phonmenon mentioned above. Moreover, the higher the sampling rate is, the wider the range of frequencies can be analyzed, and more high-frequency details can be retained.
3. `nfft` analysis: `nfft` represent the number of points in `FFT` process. The nfft (number of FFT points) does not directly affect the frequency resolution, but a higher nfft makes it easier to observe formants and results in a smoother spectrogram. Conversely, a smaller nfft produces a coarser spectrogram."
4. "log" and "linear" analysis: the last comparision is about the plot type difference. In *linear plot*, the energy is enenly distributed and as we can see the spectrum is less obvious. However.
---

## Conclusion

Short-time spectrum analysis is an important approach used to analyse speech signals. The general methodology is segmenting original signal into frames, and do short-time fourier transform on those frames. It can effectively capture the information included in the chonologic patterns of a speech signal. 

Different aspects can affect the analysis. In this assignment, we discussed two main elements: the window length and the window type. To summarize in one sentence, every selection is a tradeoff. 

- window size: If you want to have better temporal solution, you would sacrifice spectral solution for it. 
- window type: If you want better resolution, you would sacrifice worse sidelobe leaks values for it. 



