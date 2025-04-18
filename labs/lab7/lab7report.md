# **Lab7 Report**
### *李梓源     SID:12211225*
### *李沅朔     SID:12210301*

---
## Introduction
In this lab course, we learn to analyse speech signal using Linear Predictive Analysis(LPA). This approach focuses on using a set of past samples to predict the current speech sample by a linear combination. This approach regards the vocal tract as a time-varying FIR filter, and the actual voice being a stimulus signal passed through the filter. LPA is useful to various speech signal processing tasks such as encoding, compression, feature extraction and speech synthesis. 

---

## Problem 1
- **Problem description:**

Write a MATLAB program(function) to compute the real and complex cepstrum of a given siganl $x[n] = \delta[x] + 0.85\delta[x-100]$. Notably, no MATLAB functions like `cceps()` or `rceps` should be used in the code. At last, plot all three figures.

- **Solutions and process**

1. Understanding Cepstrum

Cepstrum is used to deconvlute siganls. For example, voice is sound from the vocal track, which can be viewed as a convolution of the vocal channel and the voice siganl, and cepstrum can help to deconvolute these two. The method can be illustrated by the following diagram:
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
As we can see in the result, the real cepstrum is symmetric and its x-axis have the same unit as the origin signal. Also, at the begining and the end of the signal, the siganl's frqeuency response shows more periodicity.

---

## Problem 2
- **Problem description:** 

  In this problem, we are required to write a MATLAB program to analyze a speech signal using LPC analysis methods, extract the error signal, and then use the error sinal to do exact reconstruction of the original speech file. At the end of the program, we should also plot the original speech signal, the error signal, and the resynthesized speech signal. 


- **Solution and process**:

1. We first cut the original speech signal in to frames with specified length and overlap values. A hanning window is added to the frames to prevent spectral leakage. Also, the overlapped summation of the window's response should be equal to a constant value, which could be set by using the 'periodic' parameter. 

1. For every frame, we use the self-correlation approach to solve for the linear prediction coefficients. 

1. Use formula $ \hat{s}(n)=\sum_{k = 1}^{p}a_{k}s(n - k) $ to predict the samples of frames using the calculated linear prediction coefficients. 

1. To achieve perfect reconstruction, do an addition of predicted signal and the error. 
   $$
   s(n)=\hat{s}(n)+e(n)=\sum_{k = 1}^{p}a_{k}s(n - k)+e(n)
   $$



- **Key code segment:**

1. We first define differnet parameters and cut the original waveform into frames using the buffer() function provided in MATLAB. 

```matlab
[aud, fs] = audioread('s5.wav');
lpc_size = 320;
lpc_shift = 80;
lpc_order = 12;

% 确保aud是列向量
aud = aud(:);

% 使用buffer函数将信号分帧
y = buffer(aud, lpc_size, lpc_size - lpc_shift, 'nodelay'); % 320x297
num_frames = size(y, 2); % 一共有297帧

% 创建汉宁窗
hann_win = hann(lpc_size, "periodic"); % 帧长度为320

% 初始化变量
est_frames = zeros(lpc_size, num_frames); % 复原后的帧
residual = zeros(lpc_size, num_frames);   % 残差
a_coeffs = zeros(num_frames, lpc_order + 1); 
```



2. Then for every frame, we take its self correlation and use levinson method to calculate LPC. 

```matlab
history_buffer = zeros(lpc_order, 1); % 初始化历史缓冲区

for i = 1:num_frames
    frame = y(:, i); % 当前帧, 320x1
    % 对当前帧加窗
    windowed_frame = frame .* hann_win; % 320x1

    R = xcorr(windowed_frame, lpc_order, 'unbiased'); % 计算自相关
    R = R(lpc_order + 1:end); % 取出自相关系数, 13x1
    R = R(:); % 确保是列向量
    % 计算LPC系数
    [a_coeffs(i, :), ~] = levinson(R, lpc_order); % 1x13

    extended_frame = [history_buffer; frame];

    pred_signal = filter([0 -a_coeffs(i, 2:end)], 1, extended_frame);
    
    % 只取当前帧部分的预测结果
    est_frames(:, i) = pred_signal(lpc_order+1:end);
    
    % 计算残差
    residual(:, i) = frame - est_frames(:, i);
    
    % 更新历史缓冲区用于下一帧
    history_buffer = frame(end-lpc_order+1:end);

end
```

Because the analysis needs sample points before the first sample point of a frame, we utilize a historical buffer (which is all zeros for the first frame) to store those previous samples. For every frame, we also calculate the predicted signal by using a filter function with LPC coefficient input. The error $e[n]$ (which is named residual in the code) is then calculated by subtracting the original signal with the estimated frames. 

3. To achieve perfect reconstruction, we add up the reconstructed signal and the error vector.

   ```matlab
   reconstructed_signal = zeros(length(aud),1);
   residual_sum = zeros(length(aud), 1);
   count = zeros(length(aud), 1);
   
   for i = 1:num_frames
       % 计算当前帧在原信号中的位置
       start_idx = (i-1) * lpc_shift + 1;
       end_idx = start_idx + lpc_size - 1;
       
       if end_idx <= length(reconstructed_signal)
           % 结合预测信号和残差来重构原始信号
           % s(n) = 预测信号 + 残差
           frame_reconstruction = est_frames(:,i) + residual(:,i);
           
           % 将重构帧添加到重构信号
           reconstructed_signal(start_idx:end_idx) = reconstructed_signal(start_idx:end_idx) + frame_reconstruction;
           residual_sum(start_idx:end_idx) = residual_sum(start_idx:end_idx) + residual(:, i);
           count(start_idx:end_idx) = count(start_idx:end_idx) + 1;
       end
   end
   ```




- **Result and Analysis:**

    ![image-20250418120455602](C:\Users\LiZy\AppData\Roaming\Typora\typora-user-images\image-20250418120455602.png)

- Observations

    - As shown in the figure, the reconstruction process is successful..
    - The sound of perfectly reconstructed speech is identical with the original signal. This proves that LPA successfully separates the vocal tract frequency response and the error(stimulus signals).
    - The error signal sounds hissy, resembling the stimulus fed through the vocal tracts, i.e. the airflow from the lungs. We can still understand speech from the residual signal. 
    
    

---

## Conclusion

In this lab, we have learned the basic principles of cepstrum and its applications in speech signal processing. We also learned how to use MATLAB to implement the algorithm and visualize the results. The results show that cepstrum can effectively separate the excitation source and the vocal tract response, which is useful for further analysis and processing of speech signals. We also learned how to use liftering to smooth the cepstrum and obtain a more interpretable spectrum. Overall, this lab has deepened our understanding of cepstrum and its applications in speech signal processing.



