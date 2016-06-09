% endpoint_detection: 端点检测
% author: irmo
% date: 2016.6

% fs: 采样频率
[x, fs] = audioread(['SpeechDataset/', sid, '/', sid, '_', word, '_', no, '.wav']);
soundsc(x, fs); % 播放音频

% 小波降噪
[thr,sorh,keepapp] = ddencmp('den','wv',x(:));
x = wdencmp('gbl',L2,'coif5',5,thr,'s',keepapp);
N = size(x);
x = double(x);
x = x/max(abs(x)); % 归一化

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
% zcrH = 5;
zcrL = 1;
amp = sum(abs(enframe(filter([1 -0.9375],1,x), FrameLen, FrameInc)),2);
amp1 = 2;
amp2 = 1;
ampH = min(amp1, max(amp)/4);
ampL = min(amp2, max(amp)/8);

% status: 状态
% minlen: 最小检测长度
% maxsilence: 最长允许静音长度
% count: 有效语音长度
% silence: 静音长度
maxsilence = 40;
minlen = 30;
status = 0;
count = 0;
silence = 0;

% 端点检测
x1 = 0;
x2 = 0;
for n = 1 : length(zcr)
    switch status
        % status = 0, 静音
        % status = 1, 可能开始
        % status = 2, 确认开始
        % status = 3, 结束
        case {0,1}
            if amp(n) > ampH
                x1 = max(n-count-1, 1);
                status = 2;
                silence = 0;
                count = count + 1;
            elseif amp(n) > ampL || zcr(n) > zcrL
                status = 1;
                count = count + 1;
            else
                status = 0;
                count = 0;
            end
        case 2,
            if amp(n) > ampL || zcr(n) > zcrL
                count = count + 1;
            else
                silence = silence + 1;
                if silence < maxsilence
                    count = count + 1;
                elseif count < minlen
                    status = 0;
                    silence = 0;
                    count = 0;
                else
                    status = 3;
                end
            end
        case 3,
            break;
    end
end
count = count - silence / 2;
x2 = x1 + count - 1;
result = [x1, x2];

figure(1);

subplot(311);
plot(x,'b')
title('时域波形图')
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
