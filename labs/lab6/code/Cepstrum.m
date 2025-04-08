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