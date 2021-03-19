function [c,t] = mfcc(s,fs,M,N,p)
%%
%s-signal
%fs-sampling frequency
%N-number of data in each frame
%M-overlap
%p-number of filters in filterbank
%c-output Mel-Frequency Ceptstral Coefficients

%%
% [s,fs]=audioread('C:\2021Winter\EEC201\Final project\Training_Data\s1.wav');
% N=200;M=round(2*N/3);p=24;
%Pre-Emphasis
% s = filter([1 -0.97],1,s);

%filterbanks
bank = melfb(p,N,fs);
%STFT
[s0,f,t]=stft(s,fs,'Window',hamming(N),'OverlapLength',M);
t1=s0((N/2):end, :);
t1=t1.*conj(t1);
%mfcc + normalization
c=dct(log10(bank*t1)); 
% c = c ./ max(max(abs(c))); 

end

