%% 使用DTW算法匹配.
% 定义常量
clear all;
clc;

load('words.mat');
load('ids.mat');

id_ref = {'13307130174', '14307130090', '13307130498'};
id_test = '14307130222';

%% 计算参考模板参数
disp('正在计算参考模板的参数...');
% 训练三个参考模板...

% ref1 = cell(num_words,1);
% ref2 = cell(num_words,1);
% ref3 = cell(num_words,1);
% test = cell(num_words,1);

id = id_ref{1};
for i = 1:num_words
    word = words{i};
    fname = generate_fname(id, word, '01');
    [x, fs] = audioread(fname);
    if exist(fname,'file') == 0
        error('File not exist: %s', fname);
    end
    [x1, x2] = endpoint_detect(x, fs);
    m = cal_mfcc(x, fs);
    mm = m(max(x1-2,1):min(x2-2,193),:);
    ref1(i).mfcc=mm;
end

id = id_ref{2};
for i = 1:num_words
    word = words{i};
    fname = generate_fname(id, word, '01');
    [x, fs] = audioread(fname);
    if exist(fname,'file') == 0
        error('File not exist: %s', fname);
    end
    [x1, x2] = endpoint_detect(x, fs);
    m = cal_mfcc(x, fs);
    mm = m(max(x1-2,1):min(x2-2,193),:);
    ref2(i).mfcc=mm;
end

id = id_ref{3};
for i = 1:num_words
    word = words{i};
    fname = generate_fname(id, word, '01');
    [x, fs] = audioread(fname);
    if exist(fname,'file') == 0
        error('File not exist: %s', fname);
    end
    [x1, x2] = endpoint_detect(x, fs);
    m = cal_mfcc(x, fs);
    mm = m(max(x1-2,1):min(x2-2,193),:);
    ref3(i).mfcc=mm;
end

%% 计算测试模板参数
% 获得测试模板...
disp('正在计算测试模板的参数...');
for i = 1:num_words
    word = words{i};
    fname = generate_fname(id_test, word, '14');
    [x, fs] = audioread(fname);
    if exist(fname,'file') == 0
        error('File not exist: %s', fname);
    end
    [x1, x2] = endpoint_detect(x, fs);
    m = cal_mfcc(x, fs);
    mm = m(max(x1-2,1):min(x2-2,193),:);
    test(i).mfcc=mm;
end

%% 使用DTW算法进行模板匹配
% 匹配测试
disp('正在进行模板匹配...')
dist=zeros(num_words, num_words, 3);
for i=1:num_words
    fprintf('正在测试第%2d个测试模板...\n', i);
    for j=1:num_words
        dist(i,j,1)=dtw(test(i).mfcc,ref1(j).mfcc);
        dist(i,j,2)=dtw(test(i).mfcc,ref2(j).mfcc);
        dist(i,j,3)=dtw(test(i).mfcc,ref3(j).mfcc);
    end
end

%% 计算匹配结果
disp('正在计算匹配结果...')
correct = 0;
for i=1:num_words
    [d1,j1]=min(dist(i,:,1));
    [d2,j2]=min(dist(i,:,2));
    [d3,j3]=min(dist(i,:,3));
    [d,j] = min(dist(i,:,1)+dist(i,:,2)+dist(i,:,3));
    fprintf('测试模板%2d的识别结果为 %2d. 三次匹配分别为 %2d %2d %2d, 距离%.2f %.2f %.2f\n',i,j,j1, j2, j3, d1, d2, d3);
    if i == j
        correct = correct + 1;
    end
end
fprintf('正确个数%d, 准确率:%.2f%%\n', correct, correct/num_words *100);