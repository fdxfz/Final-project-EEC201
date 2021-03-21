function codebook = getCodebook( M, N, p, q, K, distortionThreshold)
%get codebook through traning
codebook = table; % Initialize a table
for i = 1:11 % train every sample
    [s, fs] = loadWAV(i, "train");
    str = string(strcat('s', num2str(i)));
    if nargin == 0
       codebook = train1(s, fs, str, codebook);
    else
       codebook = train1(s, fs, str, codebook, ...
                       M, N, p, q, K, distortionThreshold);
    end
end
end