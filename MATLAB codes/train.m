function codebook = train(s, fs, speakerName, initialCodebook, ...
    plot_learning, M, N, p, q, K, distortionThreshold)
%train is used to intellectually finds the codebook by using the LBG method
%
%Inputs:
%s-input signal
%fs-sampling frequency (in Hz)
%speakerName - s1,s2,s3...
%initialCodebook-previous codebooks,if not exist, create a new matrix
%distortionThreshold-Maximum variance between the initial centroids and the
%                    centroids calculated from this function
%plot_learning-Bool (T/F) T -> Show K-Clustering in Action
%noise-Add Noisy Datapoints to Dataset (for Training Purposes)
%N-Number of elements in Hamming window for stft()
%p-Number of filters in the filter bank for melfb
%q-Number of filters to train on (from 1:pTrain)
%M-overlap length for stft() for more samples
%K-Number of Clusterss 
%
%Outputs:
%dataTable-Updated table of saved codebooks  

%% Default Variables
if ~exist('plot_learning', 'var') || isempty(plot_learning)
    plot_learning = true;
end
if ~exist('N', 'var') || isempty(N)
    N = 200; % Number of elements in Hamming window for stft()
end
if ~exist('M', 'var') || isempty(M)
    M = round(N*2/3); % overlap length for stft()
end
if ~exist('p', 'var') || isempty(p)
    p = 20; % Number of filters in the filter bank for melfb
end
if ~exist('q', 'var') || isempty(q)
    q = 10; % Number of filters to train on (from 1:pTrain)
end
if ~exist('K', 'var') || isempty(K)
    K = 7;  % Number of Clusters
end
if ~exist('distortionThreshold', 'var') || isempty(distortionThreshold)
    distortionThreshold = 0.03; 
end


%% preprocessing
x = preprocess(s,fs,M,N,p,q);

%% LBG
randidx = randperm(size(x, 1));
InitialCentroid = x(randidx(1:K), :);
[centroid, dmin, distortion] = LBG(x, InitialCentroid,...
                                               distortionThreshold);

%% Save to Table
centroids_cell = {centroid};
distortion_cell = {distortion};
codebook = table(centroids_cell, distortion_cell, 'RowNames', speakerName);
if ~exist('initialCodebook', 'var') || isempty(initialCodebook)
    return
else
    codebook = [initialCodebook; codebook];
    return
end
end