%% VQ算法
% 将整个数据集用来训练
clear all;
clc;

load('ids.mat');
load('words.mat');

num_no = 20;
k = 64;

disp('开始训练码本...');
code = cell(num_words,1);
tic;
for i = 1:num_words
    word = words{i};
    trainset = [];
    for j = 1:num_ids
        id = ids{j};
        for no = 1:num_no
            fname = generate_fname(id, word, num2str(no,'%02d'));
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
    fprintf('trainset size: %d %d\n', size(trainset,1), size(trainset,2));
    code{i}=vq_lbg(trainset, k);
end
t = toc;
fprintf('训练总时间为: %.2fs\n', t);
save('mats/codebook2.mat', 'code');
