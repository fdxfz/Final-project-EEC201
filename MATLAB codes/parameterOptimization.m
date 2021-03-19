%% Step 0: Get file
clc; clear;
[s2, fs2] = loadWAV(2);
[s4, fs4] = loadWAV(4);
[s6, fs6] = loadWAV(6);
[s8, fs8] = loadWAV(8);
[s10, fs10] = loadWAV(5);
[s5, fs5] = loadWAV(5);

%% Codebook Generation Demo:
codebook = train(s2, fs2, "s2");
codebook = train(s4, fs4, "s4", codebook);
codebook = train(s5, fs5, "s5", codebook);
codebook = train(s6, fs6, "s6", codebook);
codebook = train(s8, fs8, "s8", codebook);
codebook = train(s10, fs10, "s10", codebook);


%% Default Variables
[noise, deviation, N, p, q, M, K, distortionThreshold, numTrials] ...
    = defaultParameters;

%% Finding Optimal Number of Clusters (Distortion Method)
%close all
% [noise, deviation, N, p, q, M, K, thres_distortion, numTrials] ...
%     = defaultParameters;
% Kmax = 64;
% distortions = zeros(Kmax, 1);
% 
% for K = 1:Kmax
%     label = strcat("s5, K = ", num2str(K));
%     if (K==1)
%         tryK = table;
%     end
%     tryK = train(s5, fs5, label, tryK, false, ...
%         true, N, p, q, M, K, thres_distortion);
%     distortions(K, 1) = tryK.distortion_cell{K, 1};
% end
% 
% figure
% plot( (1:Kmax)', distortions); hold on;
% grid on
% xlabel('Number of K-Cluster'); ylabel('Distortion Loss');
% title(strcat('Threshold = ', ...
%     num2str(thres_distortion) ) );

%% Finding Optimal Number of Clusters (Accuracy Method)
%close all
[n,noise, deviation, M, N, p, q, K, distortionThreshold] ...
    = defaultParameters;
Kmax = 50;
trainAccuracyK = zeros(Kmax, 1);
testAccuracyK = zeros(Kmax, 1);


for K = 1:Kmax
    [trainAccuracyK(K,1), testAccuracyK(K,1)] = accuracy(n, noise, M, N, p,...
                                              q, K, distortionThreshold);
end

figure
plot( (1:Kmax)', trainAccuracyK); hold on;
plot( (1:Kmax)', testAccuracyK);
grid on
xlabel('K'); ylabel('Accuracy');
title("find optimized K" );
legend("Training process", "Testing process");

%% Finding Optimal Number of Filter Banks
[n,noise, deviation, M, N, p, q, K, distortionThreshold] ...
    = defaultParameters;
pmax = 45;

trainAccuracy_p = zeros(size(0:pmax, 1),1);
testAccuracy_p = zeros(size(0:pmax, 1),1);
for p = 1:pmax
    q = round(p*2/3); % Always get approx 66% of Filter Banks
    [testAccuracy_p(p, 1), testAccuracy_p(p, 1)] = ...
        accuracy(n, noise, M, N, p, q, K, distortionThreshold);
end

figure
plot(1:pmax, trainAccuracy_p); hold on;
plot(1:pmax, testAccuracy_p);
grid on
xlabel('p'); ylabel('Accuracy');
title("find the optimized p" );
legend("Training Dataset", "Test Dataset");

%% Finding Optimal Number of MFCC-Coefficient (Accuracy Only)
[n,noise, deviation, M, N, p, q, K, distortionThreshold] ...
    = defaultParameters;
p = 30;
row = size(2:p, 1);
qAccTrain = zeros(row,1);
qAccTest = zeros(row,1);

for q = 2:p
    [qAccTrain(q-1, 1), qAccTest(q-1, 1)] = ...
        accuracy(n, noise, M, N, p, q, K, distortionThreshold);
end

figure
plot(2:p, qAccTrain); hold on;
plot(2:p, qAccTest);
grid on
xlabel('q'); ylabel('Accuracy');

title("find optimized q" );
legend("Training Dataset", "Test Dataset");

%% Finding Optimal Number of MFCC-Coefficient w/ Distortion Considerations
defaultParameters;
p = 30;
row = size(2:p, 1);
qAcc = zeros(row,1);
qDistTest = zeros(row ,8); % row == 2:p, col == 1:8 (Speaker_id)
qDistTrain = zeros(row, 8);


for q = 2:p
    pDic = getCodebook( M, N, p, q, K, distortionThreshold);
    [pMat, qAcc(q-1, 1)] = getTestDic(pDic, deviation, M, N, p, q);
    for spkr_id = 1:8
        qDistTest(q-1, spkr_id) = pMat(spkr_id, spkr_id);
        spkrTrain_Dist = pDic{spkr_id,2}{1,1};
        qDistTrain(q-1, spkr_id) = spkrTrain_Dist;
    end
end

figure
plot(2:p, qAcc); hold on;
grid on
xlabel('q'); ylabel('Accuracy');
title('find optimized q(considering distortion)');

figure
plot(2:p, qDistTest(1:p-1, 5) ); hold on;
plot(2:p, qDistTrain(1:p-1, 5) );
grid on
xlabel('q'); ylabel('Distortion');
legend("Test Distortion", "Training Distortion")

%% Calling Default Values
function [n,noise, deviation, M, N, p, q, K, distortionThreshold] ...
    = defaultParameters;
    noise = false; % Adding Noise for training
    deviation = 2; % (float>1) Ratio for Speaker Validation
    N = 256; % Number of elements in Hamming window for stft()
    p = 20; % Number of filters in the filter bank for melfb
    q = 12; % Number of filters to train on (from 1:q)
    M = round(N*2/3); % overlap length for stft()
    K = 16;  % Number of Clusters
    distortionThreshold = 0.05; 
    n = 25;
end

%% Checking Accuracy and Tabulate Distortion Table
function [testMat, acc] = getTestDic(codebook, deviation, M, N, p, q)
spkIdx = zeros(8, 1);
for i = 1:8
    [s, fs] = loadWAV(i, "test");
    [~, ~, spkIdx(i, 1), testMat(i, :)] = test(s, fs,codebook, deviation, M, N, p, q);
end

gtIdx = (1:8)';

acc = sum( (spkIdx==gtIdx) ) ./ size(spkIdx,1);

end