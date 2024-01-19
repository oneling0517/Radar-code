function [ c, fc, Tc, fs, sample, numchirps, BW, S, numTX, numRX, SNR] = parameter_setup()
c = 3e8; %光速
fc = 77e9;  %載波頻率
Tc = 10e-6; %chirp time by TI
fs = 25.6e6; %取樣率 256/10e-6
sample = Tc*fs; %取樣點
numchirps = 128; %chirp數
BW = 600e6; %頻寬
S = BW/Tc; %chirp斜率
numTX = 4;
numRX = 8;
SNR = 20;
end