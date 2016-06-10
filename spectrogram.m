% spectrogram: 作出语谱图

[x,fs]= audioread(['SpeechDataset/', sid, '/', sid, '_', word, '_', no, '.wav']); 
soundsc(x, fs); 

specgram(x, 512, fs);  
xlabel('Time(s)');  
ylabel('Frequency(Hz)');  
title('Spectrogram'); 