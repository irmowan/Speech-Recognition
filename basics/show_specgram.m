% specgram
% 语谱图的分析

function show_specgram(f)

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