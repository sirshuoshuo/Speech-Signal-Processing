function STSA_Spectrogram(filename, resamplerate, windowlengths, FFTlengths, magscale, range, color)
    % read file
    [y, fs] = audioread(filename);
    
    % resample
    if resamplerate ~= 0
        y_new = resample(y, resamplerate, fs);
        fs = resamplerate;
    else
        y_new = y;
    end
    
    % wideband spectrogram
    Lwide = windowlengths(1) * fs * 1e-3;   % window length
    FFTwide = FFTlengths(1) * fs * 1e-3;   % FFT length
    win_wide = hamming(Lwide);
    nfft = FFTwide;
    noverlap = 0.5 * Lwide;   % window shift
    [s_wide, w_wide, t_wide] = spectrogram(y_new, win_wide, noverlap, nfft, fs);
    % log or linear
    if magscale == "linear"
        W = abs(s_wide);
    else
        W = mag2db(abs(s_wide));
    end
    % dynamic range
%     x_axis = xlim;
%     min = x_axis(1);
%     max = x_axis(2);
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
        
        figure
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
   
    
    % narrowband spectrogram
    Lnarrow = windowlengths(2) * fs * 1e-3;
    FFTnarrow = FFTlengths(2);
    win_narrow = hamming(Lnarrow);
    nfft_narrow = FFTnarrow;
    noverlap_narrow = 0.5 * Lnarrow;   % window shift
    [s_narrow, w_narrow, t_narrow] = spectrogram(y_new, win_narrow, noverlap_narrow, nfft_narrow, fs);
    % log or linear
    if magscale == "linear"
        W = abs(s_narrow);
    else
        W = mag2db(abs(s_narrow));
    end
    % dynamic range
%     x_axis = xlim;
%     min = x_axis(1);
%     max = x_axis(2);
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
end

