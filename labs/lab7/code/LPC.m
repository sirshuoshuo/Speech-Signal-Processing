    function [a, errsig] = LPC(x, order)
    frame_size = length(x);
    r = xcorr(x, x);
    r = r(frame_size : frame_size + order);
    R = toeplitz(r(1:order));              % 构建Toeplitz矩阵
    a = -R \ r(2:order+1);                 % 求解Yule-Walker方程
    a = -a;                                
    
    % 计算LPC误差信号
    errsig = filter([1; -a], 1, x);
    end

