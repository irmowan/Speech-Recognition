
function ccc = mfcc(f)
% mfcc: 计算语音的 mfcc
% ccc: 返回的 mfcc 特征，帧数*24维

% MFCC计算:
% 分帧 -> 预加重 -> 加汉明窗 -> 短时傅里叶变换 -> 得到频谱;

% fs: 采样频率
[x, fs] = audioread(f);

% 产生Mel三角滤波器参数并归一化
bank = melbankm(24, 256, fs, 0, 0.4, 't');
bank = full(bank);          % 将稀疏矩阵转换成完整的矩阵
bank = bank/max(bank(:));   % 归一化

subplot(211)
plot(bank')
title('Mel三角滤波器')

% 产生离散余弦变换的参数
dctcoef = zeros(12,24);
for k = 1:12
    n = 0:23;
    dctcoef(k, :) = cos((2*n+1)*k*pi/(2*24));
end

% 归一化倒谱提升窗口
w = 1+6*sin(pi*(1:12)./12);
w = w/max(w);


% 预加重滤波器
xx = filter([1 -0.9375], 1, double(x));

% 语音信号分帧
xx = enframe(xx, 256, 80);

% MFCC计算的核心部分
% 遍历每帧,计算MFCC参数
m = zeros(size(xx,1), 12);
for i = 1:size(xx,1)
    y = xx(i,:);
    s = y'.*hamming(256);           % 加窗
    t = abs(fft(s));                % 求频谱
    t = t.^2;                       % 平方得到能量谱
    c = log(bank*t(1:129));         % 滤波，对滤波器输出取对数得到对数功率谱
    c1= dctcoef*c;                  % 进行反离散余弦变换
    c2= c1.*w';                     % 提升窗口
    m(i,:)=c2';
end

% 差分参数
dtm=zeros(size(m));
for i = 3:size(m,1)-2
    dtm(i,:) = -2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
end

dtm = dtm/3;

% 合并mfcc参数和一阶差分mfcc参数
ccc = [m dtm];

% 去除首位两帧，因为这两帧的一阶差分参数为0
ccc = ccc(3:size(m,1)-2, :);

subplot(212)
% ccc_1 = ccc(:,1);
plot(ccc);
title('MFCC');
return
