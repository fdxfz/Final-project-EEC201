function timedomain(s,fs,id)
%plot the signal in time domain
%   Detailed explanation goes here
t = (0:length(s)-1)/fs;
figure; 
plot(t, s); 
xlim([min(t), max(t)]);
xlabel('Time (s)'); ylabel('Amplitude');
title(strcat('time domain',int2str(id)))
end

