clear all; clc;
codebook = getCodebook();
randomID = randperm(8);

for i=1:8
    [s,fs]=loadWAV(randomID(i));
    s = addNoise(s, "white", 30); % Add noise
    IDout(i) = test1(s, fs, codebook); % Get test output
end
randomID
IDout
