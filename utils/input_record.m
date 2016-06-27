function [x, fs] = input_record()
%% 录入一段语音
Time = 2;
fs = 8000;
nBits = 16;
recObj = audiorecorder(fs, nBits, 1);
input('Enter to start speaking.');
recordblocking(recObj, Time);
disp('End of Recording.');
x = getaudiodata(recObj);
return 
