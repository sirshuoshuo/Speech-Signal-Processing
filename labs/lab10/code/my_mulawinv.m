function x = my_mulawinv(y, mu)
    % 计算幅度部分
    abs_x = ( (1 + mu) .^ abs(y) - 1 ) / mu;
    % 恢复符号
    x = abs_x .* sign(y);
end

