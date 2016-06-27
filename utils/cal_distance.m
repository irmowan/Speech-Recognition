function d = cal_distance(x, y)
%% 测距
[M1, N] = size(x);
[M2, P] = size(y);
if (M1 ~= M2)
    error('维度不匹配，无法测距');
end
d = zeros(N, P);
if (N < P)
    copies = zeros(1,P);
    for n = 1:N
        d(n,:) = sum((x(:, n+copies) - y) .^2, 1);
    end
else
    copies = zeros(1,N);
    for p = 1:P
        d(:,p) = sum((x - y(:, p+copies)) .^2, 1)';
    end
end
d = d.^0.5;
return
