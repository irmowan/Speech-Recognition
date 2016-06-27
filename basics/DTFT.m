% 利用DFT求DTFT
r = 3;
N = 16;
n = 1:N;
x = cos(2*pi * 3 * n/N);

subplot(321);
bar(x,0.01);

subplot(322);
X = abs(fft(x));
bar(X, 0.01);

subplot(323);
y = [x, zeros(1, 64-N)];
bar(y, 0.01);

subplot(324);
Y = abs(fft(y));
bar(Y, 0.01);

subplot(325);
z = [x, zeros(1, 512-N)];
bar(z, 0.01);

subplot(326);
Z = abs(fft(z));
bar(Z, 0.001);

saveas(gcf, strcat(pwd,'/results/DTFT'),'jpg');
