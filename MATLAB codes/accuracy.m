function [trainAccuracy,testAccuracy] = accuracy(n, noise, M, N, p, q, K, distortionThreshold)
%UNTITLED11 Summary of this function goes here
%n-number of trials
% Parameters
if ~exist('n', 'var') || isempty(n)
    n =  25; % Number of times to iterate
end
rValid = 2;

% Declare Variables
failedTrain = 0; failedTest = 0;
trainFails = zeros(1, 11); testFails = zeros(1, 8);

% Main
for j = 1:n
    % Train with all train data
    if nargin < 2
        codebook = getCodebook();
    else
        codebook = getCodebook(noise, N, p, q, M, K, distortionThreshold); 
    end

    % check train accuracy
    for i = 1:11
        [s, fs] = loadWAV(i, "train");
        
        if nargin == 0 || nargin == 1
            outSpkr = test(s, fs, codebook);
        else
            outSpkr = test(s, fs, codebook, rValid, N, p, q, M);
        end        
        spkrRef = string(strcat("s", num2str(i)));
        if outSpkr ~= spkrRef
            failedTrain = failedTrain + 1;
            trainFails(i) = trainFails(i) + 1;
        end
    end

    % check test accuracy
    for i = 1:8
        [s, fs] = loadWAV(i, "test");
        
        if nargin == 0 || nargin == 1
            outSpkr = test(s, fs, codebook);
        else
            outSpkr = test(s, fs, codebook, rValid, N, p, pTrain, M);
        end
        
        spkrRef = string(strcat("s", num2str(i)));
        if outSpkr ~= spkrRef
            % fprintf("Test %i (Test) Failed: out=%s\n", i, outSpkr);
            failedTest = failedTest + 1;
            testFails(i) = testFails(i) + 1;
        end
    end
end

% Report Percentages
totalTrain = 11 * n; totalTest = 8 * n;
trainAccuracy = (1-failedTrain/totalTrain);
testAccuracy = (1-failedTest/totalTest);

fprintf("Against Train Data: Failed %i/%i, Acc=%.2f%%\n", failedTrain, ...
    totalTrain, accTrain*100);
fprintf("Against Test Data: Failed %i/%i, Acc=%.2f%%\n", failedTest, ...
    totalTest, accTest*100);

if any(trainFails)
    trainFails
end
if any(testFails)
    testFails
end

end

