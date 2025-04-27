function [snr, e] = SNR(xh, x)
    L = length(x);
    sum_sig = 0;
    sum_err = 0;
    for i=1:L
        sum_sig = sum_sig + x(i).^2;   % ·ÖºÅ£¡£¡£¡
        sum_err = sum_err + (x(i)-xh(i)).^2;   % ·ÖºÅ£¡£¡£¡
    end
    snr = 10*log10(sum_sig/sum_err)
    e = mulaw(xh, 225) - x;
%     mean(e)
end

