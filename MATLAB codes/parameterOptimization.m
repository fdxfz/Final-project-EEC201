%%
clc; clear;
[s2, fs2] = loadWAV(2);
[s4, fs4] = loadWAV(4);
[s6, fs6] = loadWAV(6);
[s8, fs8] = loadWAV(8);
[s10, fs10] = loadWAV(5);
[s5, fs5] = loadWAV(5);


codebook = train1(s2, fs2, "s2");
codebook = train1(s4, fs4, "s4", codebook);
codebook = train1(s5, fs5, "s5", codebook);
codebook = train1(s6, fs6, "s6", codebook);
codebook = train1(s8, fs8, "s8", codebook);
codebook = train1(s10, fs10, "s10", codebook);

%% Finding K
close all hidden
[n,noise, deviation, M, N, p, q, K, distortionThreshold] ...
    = defaultParameters;
Kmax = 60;
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
legend("Training", "Testing");

%% Finding p
[n,noise, deviation, M, N, p, q, K, distortionThreshold] ...
    = defaultParameters;
K =7; 
pmax = 50;

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

%% Finding q
[n,noise, deviation, M, N, p, q, K, distortionThreshold] ...
    = defaultParameters;

K = 7; p = 20;
row = size(2:p, 1);
qAccTrain = zeros(row,1);
qAccTest = zeros(row,1);

for q = 1:p
    [qAccTrain(q, 1), qAccTest(q, 1)] = ...
        accuracy(n, noise, M, N, p, q, K, distortionThreshold);
end

figure
plot(1:p, qAccTrain); hold on;
plot(1:p, qAccTest);
grid on
xlabel('q'); ylabel('Accuracy');

title("find optimized q" );
legend("Training Dataset", "Test Dataset");

%% Finding q in Distortion Considerations
defaultParameters;
p = 20;
row = size(1:p, 1);
qAcc = zeros(row,1);
qDistTest = zeros(row ,8); % row == 2:p, col == 1:8 (Speaker_id)
qDistTrain = zeros(row, 8);


for q = 1:p
    pDic = getCodebook( M, N, p, q, K, distortionThreshold);
    [pMat, qAcc(q-1, 1)] = getTestDic(pDic, deviation, M, N, p, q);
    for spkr_id = 1:8
        qDistTest(q-1, spkr_id) = pMat(spkr_id, spkr_id);
        spkrTrain_Dist = pDic{spkr_id,2}{1,1};
        qDistTrain(q-1, spkr_id) = spkrTrain_Dist;
    end
end

figure
plot(1:p, qAcc); hold on;
grid on
xlabel('q'); ylabel('Accuracy');
title('find optimized q(considering distortion)');

figure
plot(1:p, qDistTest(1:p, 5) ); hold on;
plot(1:p, qDistTrain(1:p, 5) );
grid on
xlabel('q'); ylabel('Distortion');
legend("Test Distortion", "Training Distortion")

%% Default Values
function [n,noise, deviation, M, N, p, q, K, distortionThreshold] ...
    = defaultParameters;
    noise = false;
    deviation = 2;
    N = 248;
    M = round(N*2/3);
    K = 7;    
    p = 20;
    q = 12;
    distortionThreshold = 0.03; 
    n = 25;
end

%% Checking Accuracy and Tabulate Distortion Table
function [testMat, acc] = getTestDic(codebook, deviation, M, N, p, q)
spkIdx = zeros(8, 1);
for i = 1:8
    [s, fs] = loadWAV(i, "test");
    [~, ~, spkIdx(i, 1), testMat(i, :)] = test1(s, fs,codebook, deviation, M, N, p, q);
end

gtIdx = (1:8)';

acc = sum( (spkIdx==gtIdx) ) ./ size(spkIdx,1);

end