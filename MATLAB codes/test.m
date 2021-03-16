function [name, confident, spkdmin, distort_compare] = test(s, fs,...
    codebook, deviation, M, N, p)
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
%speakerName-name of the speaker obtained by matching the input signal to
%codebook
%   confident - Boolean (T/F) -> True: Valid Speaker
%   spkdmin - (int) Speaker Index at codebook Table
%   distort_compare - (numSpkr*1) distance/distortion between
%       Input Sound Data and codebook's centroid


%% Default Variables
if ~exist('deviation', 'var') || isempty(deviation)
    deviation = 0.2; % Error Deviation Tolerance to validate speaker
end
if ~exist('N', 'var') || isempty(N)
    N = 256; % Number of elements in Hamming window for stft()
end
if ~exist('M', 'var') || isempty(M)
    M = round(N*2/3); % overlap length for stft()
end
if ~exist('p', 'var') || isempty(p)
    p = 20; % Number of filters in the filter bank for melfb
end

%% Preprocessing
c = mfcc(s,fs,M,N,p);
distort_compare = zeros(size(codebook,1), 1);

%% Computing all errors/distance for each codebook/centroid membership
for L = 1:size(codebook, 1)
    centroid = codebook.centroid_cell{L,1}; % Table -> Struct -> Array
    K = size(centroid, 1); % Number of clusters
    dmin = zeros(size(c,1), 1);
    distance = zeros(size(c, 1), K);
    for i = 1:K
        d = bsxfun(@minus, c, centroid(i,:));
        distance(:, i) = sum(d.^2, 2);
    end
    [dmin_value dmin] = min(distance, [], 2);

    distortion = 0; %initial distortion of codebook
    for i = 1:K
        n = find(dmin == i);
        diff = bsxfun(@minus, c(n, :), centroid(i,:));
        distortion = distortion + sum(diff.^2, 'all');
    end
    distortion = distortion ./ size(c, 1);
end

%% Finding the speaker
sortedDistortion = sort(distortion);
spkdmin = find(distortion == sortedDistortion(1));
delta_distort = abs(sortedDistortion(2) - sortedDistortion(1));
if ( delta_distort ./ sortedDistortion(1) < deviation)
    confident = false;
else
    confident = true;
end

name = codebook(spkdmin, :).Properties.RowNames;
name = string(name); % Cast from cell to string
end