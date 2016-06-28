
clear all;
clc;

load('words.mat');
load('ids.mat');
load('codebook.mat');

disp('开始测试...');
dist = ones(num_words);

num_no = 20;
nums = 0;
correct = 0;
tic;
for i = 1:num_words
    word = words{i};
    fprintf('测试第%d个单词...\n', i);
    for l = 1:num_ids
        id_test = ids{l};
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
                d = cal_distance(mm', code{j});
                dist(j) = sum(min(d,[],2)) / size(d,1);
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
