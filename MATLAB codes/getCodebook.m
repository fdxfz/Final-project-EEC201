function codebook = getCodebook( M, N, p, q, K, distortionThreshold)
%get codebook through traning
codebook = table; % Initialize a table
for i = 1:11 % train every sample
    [s, fs] = loadWAV(i, "train");
    str = string(strcat('s', num2str(i)));
    if nargin == 0
       codebook = train(s, fs, str, codebook, false);
    else
       codebook = train(s, fs, str, codebook, false, ...
                       M, N, p, q, K, distortionThreshold);
    end
end
end