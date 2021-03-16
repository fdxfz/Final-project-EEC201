function [s, fs, t] = loadWAV(id, type)
%load the wav. file to the program
%id-speaker id 1,2,3...,11
if nargin == 1
   type = "train";
end
    
if type == "train" || type == "test"
        file = string( strcat('C:\2021Winter\EEC201\Final project\Data\', type, '\s', int2str(id), '.wav') );
else
    error('Unrecognized type: Must be train or test');
end

[s, fs] = audioread(file);
t = (0:length(s)-1) / fs;
if min(size(s)) > 1
   s = s(:, 1); % If more channel, get only first
end
end

