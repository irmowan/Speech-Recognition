% endpoint_detetion
% 批量导出端点检测图像
% 注，此处仅导出no='01'的图像，供展示使用
clear all;
clc;

load('ids.mat');
load('words.mat');
FrameInc = 80;
FrameLen = 256;

for i = 1:num_words
    word = words{i};
    for j = 1:num_ids
        id = ids{j};
        
        fname = generate_fname(id, word, '01');
        if exist(fname,'file') == 0
            continue
        end
        
        [x, fs] = audioread(fname);
        fprintf('处理%s  %s...\n', id, word);
        [x1, x2] = endpoint_detect(x, fs);
        
        plot(x,'b');
        title('时域波形图');
        hold on
        plot([x1*FrameInc x1*FrameInc], [-1 1], 'r', [x2*FrameInc+FrameLen x2*FrameInc+FrameLen], [-1, 1], 'r');
        saveas(gcf, strcat(pwd,'/results/endpoint/',id, '_', word),'jpg');
        clf;
    end
end