function y = MedianSmoother(x, L)
%MEDIANSMOOTHER 给出窗长度为L的中值滤波

padding_length = floor(L/2);
x_padded = [ones(1, padding_length)*x(1), x, ones(1, padding_length)*x(end)];
y = zeros(size(x));

for i = 1:length(x)
    window = x_padded(i:i+L-1);
    y(i) = median(window);
end

end

