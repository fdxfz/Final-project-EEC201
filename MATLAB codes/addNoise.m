function [sout,noise] = addNoise(s,type,SNR)
%This function used to add specific noise you want into the input signal
%s-input signal
%type-type of noise, including 'pink', 'white', 'brown', 'blue', 'purple'
%     the default type is white
%SNR-default value: 30dB

%%
% default value
if ~exist('type', 'var') || isempty(type)
    type = 'white';
end

if ~exist('SNR', 'var') || isempty(SNR)
    SNR = 30; %dB
end

% Warn if Signal-to-Noise Ratio is too low
if SNR<10 %dB
   warning('Input SNR is too low! It should be higher than 10dB');
end

samp=length(s);
numChan = 1;
bOut = (type ~= "brown");

% Get Noise
noise = dsp.ColoredNoise(type, samp, numChan, 'BoundedOutput', bOut);
noise = noise();
g = mean(abs(s))/db2mag(SNR); %adjust to the input SNR
G = g/mean(abs(noise));
noise = G*noise;

sout = s + noise;
  
end
