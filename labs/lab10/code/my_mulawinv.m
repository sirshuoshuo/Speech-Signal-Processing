function x = my_mulawinv(y, mu)
    % ������Ȳ���
    abs_x = ( (1 + mu) .^ abs(y) - 1 ) / mu;
    % �ָ�����
    x = abs_x .* sign(y);
end

