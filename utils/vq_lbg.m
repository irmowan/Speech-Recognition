function r = vq_lbg(d, k)
%% 训练码本r
% d为训练数据
% k为需要训练出的码字个数

% d.size = 24, Frames;
e = .01;
%返回每一行均值，形成第一个码字，即所有帧的特征矢量的均值
r = mean(d, 2);
dpr = 10000;    % 平均失真 D0
for i = 1:log2(k)   % 要求质心数为k时，进行的分裂次数
    r = [r*(1+e), r*(1-e)]; % 分裂成两倍列数
    while (1 == 1)
        z = cal_distance(d, r); %计算d和r的欧式距离
        [m,ind] = min(z, [], 2); % 找到z中每一行最小数返回到m，并把列号返回到ind
        t = 0; % 平均失真
        for j = 1:2^i
            r(:, j) = mean(d(:, ind == j), 2);
            x = cal_distance(d(:, ind == j), r(:, j));
            for q = 1:length(x)
                t = t + x(q);
            end
        end
        % 若相对失真小于e则停止
        if (((dpr - t)/t) < e)
            break;
        else
            dpr = t;
        end
    end
end