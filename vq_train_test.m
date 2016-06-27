%% 定义常量
clear all;
clc;

load('ids.mat');
load('words.mat');

num_no = 20;
train = 22;
test = num_ids - train;
assert(test > 0);

k = 64;

%% Train VQ

disp('开始训练码本...');
code = cell(num_words,1);
tic;
for i = 1:num_words
    word = words{i};
    trainset = [];
    for j = 1:train
        id = ids{j};
        for no = 1:num_no
            fname = generate_fname(id, word, num2str(no, '%02d'));
            if exist(fname,'file') == 0
                continue
            end
            [x, fs] = audioread(fname);
            [x1, x2] = endpoint_detect(x, fs);
            m = cal_mfcc(x, fs);
            mm = m(max(x1-2,1):min(x2-2,193),:);
            trainset = [trainset, mm'];
        end
    end
    fprintf('训练第%2d个单词的码本...\n', i);
    code{i}=vq_lbg(trainset, k);
end
t = toc;
fprintf('训练总时间: %.2fs\n', t);
disp('保存码本...');
save('mats/code.mat', 'code');

%% Test VQ

disp('开始测试...');
dist = ones(num_words);

% load('codebook.mat');

nums = 0;
correct = 0;
tic;
for i = 1:num_words
    word = words{i};
    fprintf('测试第%d个单词...\n', i);
    for l = 1:test
        id_test = ids{train+l};
        for no = 1:num_no
            fname = generate_fname(id_test, word, num2str(no,'%02d'));
            if exist(fname,'file') == 0
                continue
            end
            nums = nums + 1;
            [x, fs] = audioread(fname);
            [x1, x2] = endpoint_detect(x, fs);
            m = cal_mfcc(x, fs);
            mm = m(max(x1-2,1):min(x2-2,193),:);
            
            dist = ones(1, num_words);
            for j = 1:num_words
                d = cal_distance(mm', code{j});    %计算得到模板和要判断的声音之间的“距离”
                dist(j) = sum(min(d,[],2)) / size(d,1);  %变换得到一个距离的量
            end
            [d, min_word] = min(dist(:));
%             fprintf('测试%s的结果是%s\n', fname, words{min_word});
            if min_word == i
                correct = correct + 1;
            end
            clear dist;
        end
    end
end
t = toc;
fprintf('测试总时间: %.2fs\n', t);
fprintf('测试集大小: %d\n', nums);
fprintf('正确的个数: %d\n', correct);
fprintf('测试准确率: %.2f%%\n',correct/nums*100);
