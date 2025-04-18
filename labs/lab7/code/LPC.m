    function [a, errsig] = LPC(x, order)
    frame_size = length(x);
    r = xcorr(x, x);
    r = r(frame_size : frame_size + order);
    R = toeplitz(r(1:order));              % ����Toeplitz����
    a = -R \ r(2:order+1);                 % ���Yule-Walker����
    a = -a;                                
    
    % ����LPC����ź�
    errsig = filter([1; -a], 1, x);
    end

