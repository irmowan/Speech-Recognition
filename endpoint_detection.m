% endpoint_detection: 端点检测
% author: irmo
% date: 2016.6

% fs: 采样频率
[x, fs] = audioread(['SpeechDataset/', sid, '/', sid, '_', word, '_', num2str(no), '.wav']);
soundsc(x, fs); % 播放音频

t = x;
N = size(x);
x = double(x);
x = x/max(abs(x)); % 归一化

% status: 状态
% minlen: 最小检测长度
status = 0;
minlen = 15;

% 确定帧长、帧移并切割
FrameLen = 240;
FrameInc = 80;
tmp1  = enframe(x(1:end-1), FrameLen, FrameInc);
tmp2  = enframe(x(2:end)  , FrameLen, FrameInc);

signs = (tmp1.*tmp2) < 0;
diffs = (tmp1 -tmp2) > 0.02;

% zcr: 过零率
% amp: 短时能量
% ampH: 短时能量 高阈值
% ampL: 短时能量 低阈值ֵ
zcr   = sum(signs.*diffs, 2);   
amp = sum(abs(enframe(filter([1 -0.9375],1,x), FrameLen, FrameInc)),2);
ampH = min(10, max(amp)/4);
ampL = min(2, max(amp)/8);
% b = max(amp)/4
% c = max(amp)/8

% 端点检测
x1 = 0;
x2 = 0;
for n = 1 : length(zcr)
    switch status
        case 0,
            if amp(n) > ampH
                x1 = n;
                status = 1;
            end
        case 1,
            if amp(n) < ampH
                x2 = n;
                count = x2 - x1;
                status = 3;
            end
        case 3,
            if count < minlen
                status = 0;
            end
    end
end
result = [x1, x2];

figure(1);

subplot(311);
plot(x,'b')
title('波形图')
hold on
plot([x1*FrameInc x1*FrameInc], [-1 1], 'r', [x2*FrameInc+FrameLen x2*FrameInc+FrameLen], [-1, 1], 'r');

subplot(312);
plot(zcr);
title('过零率')
xlabel('֡帧')

subplot(313);
plot(amp);
title('短时能量');
xlabel('帧');
