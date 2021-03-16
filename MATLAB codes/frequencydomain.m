function frequencydomain(s,fs)
%plot figure in frequency domain
%   Detailed explanation goes here
N = length(s);
f = fs*(0:(N/2))/N;
Xk = fft(s, N);
Pk = abs( Xk(1:(floor(N/2)+1) ) );
figure; 
plot(f, Pk);
xlabel('Frequency (Hz)'); ylabel('Amplitude');
title('Frequency Spectra');
end

