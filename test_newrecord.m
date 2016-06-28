
%% 对输入的语音进行检测
% 输入一段语音进行检测.
clear all;
clc;

while true
    [x, fs] = input_record();
    clf;
    plot(x);
    
    load('codebook.mat', 'code');
    load('words');
    
    [x1, x2] = endpoint_detect(x, fs);
    m = cal_mfcc(x, fs);
    mm = m(max(x1-2,1):min(x2-2,193),:);
    
    plot(x);
    hold on;
    FrameInc=80;
    FrameLen=256;
    plot([x1*FrameInc x1*FrameInc], [-1 1], 'r', [x2*FrameInc+FrameLen x2*FrameInc+FrameLen], [-1, 1], 'r');
    
    dist = ones(1, num_words);
    for j = 1:num_words
        d = cal_distance(mm', code{j});
        dist(j) = sum(min(d,[],2)) / size(d,1);
        fprintf('与单词%6s距离为 %.2f \n', words{j}, dist(j));
    end
    
    [min_d, min_j] = min(dist);
    fprintf('该词可能是: %s.\n', words{min_j});
end