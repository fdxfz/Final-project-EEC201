function [trainAccuracy,test1Accuracy] = accuracy(n, noise, M, N, p, q, K, distortionThreshold)
%UNTITLED11 Summary of this function goes here
%n-number of trials
% Parameters
if ~exist('n', 'var') || isempty(n)
    n =  25; % Number of times to iterate
end
deviation = 2;

% Declare Variables
failedTrain = 0; failedtest1 = 0;
trainFails = zeros(1, 11); test1Fails = zeros(1, 8);

% Main
for j = 1:n
    % Train with all train data
    if nargin < 2
        codebook = getCodebook();
    else
        codebook = getCodebook(M, N, p, q, K, distortionThreshold); 
    end

% check train accuracy
for i = 1:11
    [s, fs] = loadWAV(i, "train");  
    if nargin == 0 || nargin == 1
       so = test1(s, fs, codebook); %speaker recognized by the system
    else
       so = test1(s, fs,codebook, deviation, M, N, p ,q);
    end        
       sr = string(strcat("s", num2str(i))); %true answere
    if so ~= sr
       failedTrain = failedTrain + 1;
       trainFails(i) = trainFails(i) + 1;
    end
end

% check test accuracy
for i = 1:8
    [s, fs] = loadWAV(i, "test");
        
    if nargin == 0 || nargin == 1
       so = test1(s, fs, codebook);
    else
       so = test1(s, fs,codebook, deviation, M, N, p ,q);
    end
        
    sr = string(strcat("s", num2str(i)));
    if so ~= sr
       failedtest1 = failedtest1 + 1;
       test1Fails(i) = test1Fails(i) + 1;
    end
end
end

% Report Percentages
totalTrain = 11 * n; totaltest1 = 8 * n;
trainAccuracy = (1-failedTrain/totalTrain);
test1Accuracy = (1-failedtest1/totaltest1);
end

