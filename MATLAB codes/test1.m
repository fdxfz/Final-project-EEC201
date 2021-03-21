function [name, confident, speakerIndex, distortion] = test1(s, fs,...
    codebook, deviation, M, N, p ,q)
%test tries to recognize the speaker of the inputsignal using codebooks
%obtained by traning process
%Inputs:
%s-input signal
%fs-sampling frequency (in Hz)
%speakerName - s1,s2,s3...
%initialCodebook-previous codebooks,if not exist, create a new matrix
%N-Number of elements in Hamming window for stft()
%p-Number of filters in the filter bank for melfb
%q-Number of filters to train on (from 1:pTrain)
%M-overlap length for stft() for more samples
%deviation-maximum deviation between the first 2 best
%Output:
%name-name of the speaker obtained by matching the input signal to
%codebook
%confident - Boolean (T/F) -> True: Valid Speaker
%speakerIndex - (int) Speaker Index at codebook Table
%distortion - (numSpkr*1) distance between input data and codebook's centroid


%% Default Variables
if ~exist('deviation', 'var') || isempty(deviation)
    deviation = 0.2; % Error Deviation Tolerance to validate speaker
end
if ~exist('N', 'var') || isempty(N)
    N = 248; 
end
if ~exist('M', 'var') || isempty(M)
    M = round(N*2/3);
end
if ~exist('p', 'var') || isempty(p)
    p = 20; 
end
if ~exist('q','var') || isempty(q)
    q = 12;
end

%% Preprocessing
x = preprocess(s,fs,M,N,p,q);
distortion = zeros(size(codebook, 1),1); %initial distortion of codebook
%% calculate distortion between the input signal and centroids in codebook
for L = 1:size(codebook, 1)
    centroid = codebook.centroids_cell{L,1}; %centroid of the Lth signal
    K = size(centroid, 1); % Number of clusters
    dmin = zeros(size(x,1), 1);
    distance = zeros(size(x, 1), K);
    for i = 1:K
        d = bsxfun(@minus, x, centroid(i,:));
        distance(:, i) = sum(d.^2, 2);
    end
    [dmin_value dmin] = min(distance, [], 2);

    for i = 1:K
        n = find(dmin == i);
        if ~isempty(n)
        diff = bsxfun(@minus, x(n, :), centroid(i,:));
        distortion(L,1) = distortion(L,1) + sum(diff.^2, 'all');
        end
    end
end
distortion = distortion ./ size(x, 1);

%% Finding the speaker
sortedDistortion = sort(distortion);
speakerIndex = find(distortion == sortedDistortion(1));
delta_distort = abs(sortedDistortion(2) - sortedDistortion(1));
if ( delta_distort/sortedDistortion(1) < deviation)
    confident = false;
else
    confident = true;
end
name = codebook(speakerIndex, :).Properties.RowNames;
name = string(name); % Cast from cell to string
end