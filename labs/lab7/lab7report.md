# **Lab7 Report**
### *李梓源     SID:12211225*
### *李沅朔     SID:12210301*

---
## Introduction
---
## Introduction
In this lab course, we learned a new method to analysis signals called cepstrum. Intuitively, cepstrum is the *frequency response of the frequency domain*, which is used to separate two signals doing convolution. This method will be used further in speech siganl processing and analysis, and in this lab problems are designed for us to understand its basic principles and test it on several expample siganls. 

---

## Problem 1
### **Problem description:** 

Develop a MATLAB program to perform Linear Predictive Coding (LPC) analysis on a specified frame of speech and display the following results:

1. Original Speech Signal: Plot the original speech signal for the specified frame.

2. LPC Error Signal: Display the error signal obtained from the LPC analysis for the same frame.

3. Log Magnitude Spectrum: Show the short-time Fourier transform (STFT) log magnitude spectrum (in dB) of the original signal, overlaid with the LPC spectrum for the specified frame.

4. Error Signal Spectrum: Plot the log magnitude spectrum of the LPC error signal.

### **Solutions and process** 
1. Process Overvirw
A function `LPC` is written solely to calculate the LPC residule signal.
- **Signal Preprocessing**  
   - Load the test wav file `test_16k.wav`.  
   - Extract a fixed-length frame (e.g., 640 samples starting at sample 6000).  

- **LPC Parameter Estimation**  
   - Compute autocorrelation and solve Yule-Walker equations to derive LPC coefficients.  

- **Spectral Analysis**  
   - Compare the original signal’s spectrum with the LPC model’s spectrum.  
   - Analyze the error signal’s spectral.   


### Key Steps  
This is the main idea of LPC: to use the earlier parameters to predict the future parameters:
![image-20250408201812296](./asset//LPC_principle.png)

#### (1) Autocorrelation Computation  
We first calculate \(R(k)\) for lags \(k = 0\) to \(p\):  
  $$
  R(k) = \sum_{n} s(n) \cdot s(n+k)
  $$
In MATLAB, we use the function `xcorr` to do this task.    

#### (2) Yule-Walker Equation Solving  
First, we constuct a Toeplitz matrix using MATLAB function `toeplitz`, then using `-R \ r(2:order+1)`to solve the Yule-Walker equation  

#### (3) Residual Signal Generation  
Using a math representation:
$$
  e(n) = s(n) + \sum_{k=1}^{p} a_k \cdot s(n-k)
$$  
Additionally, we further pass the signal to a filter. The function `filter` is used.


   

### **Key code segment:**

The code follows the ideas mentioned above and is devided into real_cep calculation and complex_cep calculation
```matlab

    [x, fs] = audioread('test_16k.wav');
    x = x(:, 1); 
    start_sample = 6000;
    frame_size = 640;
    order = 12;
    frame = x(start_sample : start_sample + frame_size - 1);
    [a, errsig] = LPC(frame, order);
    
    nfft = 2048;
    freq = (0:nfft/2) * fs / nfft;     
    spec_orig = abs(fft(frame, nfft));
    spec_orig = 20*log10(spec_orig(1:nfft/2+1));
    
    [h, ~] = freqz(1, [1; -a], nfft/2+1, fs);
    spec_lpc = 20*log10(abs(h));
    spec_err = abs(fft(errsig, nfft));
    spec_err = 20*log10(spec_err(1:nfft/2+1));
    
    figure('Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.8]);
    subplot(2,2,1);
    plot((0:frame_size-1)/fs, frame);
    title('Original Speech Frame');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
    
    subplot(2,2,2);
    plot((0:frame_size-1)/fs, errsig);
    title('LPC Error Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
    
    subplot(2,2,3);
    plot(freq, spec_orig, 'b', 'LineWidth', 1.5);
    hold on;
    plot(freq, spec_lpc, 'r', 'LineWidth', 1.5);
    hold off;
    title('Spectrum Comparison');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    legend('Original Signal', 'LPC Spectrum');
    grid on;
    ylim([-50, max(spec_orig)+10]);
    
    subplot(2,2,4);
    plot(freq, spec_err);
    title('Error Signal Spectrum');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    grid on;
    saveas(gcf, 'D:/作业提交/大三 下/语音信号处理/lab7/P1.png', 'png')
  
    

    function [a, errsig] = LPC(x, order)
    frame_size = length(x);
    r = xcorr(x, x);
    r = r(frame_size : frame_size + order);
    R = toeplitz(r(1:order));              % 构建Toeplitz矩阵
    a = -R \ r(2:order+1);                 % 求解Yule-Walker方程
    a = -a;                               
  
    errsig = filter([1; -a], 1, x);
    end

```


- **Result and Analysis:**

![P1](./asset/P1.png)
As we can see in the result, LPC successfully captures main formant structure. Since we did a autocorrelation, the error at the beginnig and at the end is declined.
Also, in the error signal spectrum, the signal is flat, which meets our expectations.

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
      
    
  
-  Observations

    - **N:** N is the length of the given siganl, when the signal length grow longer, a larger nfft is required theoretically.
    - **nfft:** the number of `fft()` specifies the accuracy of the cepstrum. when nfft is larger than N, the quefrency performs much more precise. However, when nfft is smaller than N, the signal is truncated and shows less details.
    - **a:** The parameter a directly change the expression of the signal, and as we can see the difference clearly in the result.

    



---

## Conclusion

In this lab, we have learned the basic principles of LPC, which is a useful method to predict the properties of differnt speech signals.



