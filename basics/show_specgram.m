function show_specgram(f)
%% 展示不同窗口尺度的语谱图
% f: 输入文件路径
[x,fs]= audioread(f); 
soundsc(x, fs); 

subplot(221);
specgram(x, 8, fs);

subplot(222);
specgram(x, 64, fs);  

subplot(223);
specgram(x, 512, fs);  

subplot(224);
specgram(x, 4096, fs);

return