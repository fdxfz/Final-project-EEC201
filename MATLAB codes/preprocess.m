function output = preprocess(s,fs,M,N,p,q,noise)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
if ~exist('noise', 'var') || isempty(noise)
    noise = false;
end

s1=deleteZero(s);
[c, t] = mfcc(s1, fs, M, N, p);


if noise
   sPink = addNoise(s1, 'pink');
   sBrown = addNoise(s1, 'brown');
   sWhite = addNoise(s1, 'white');

   [cPink, t] = mfcc(sPink, fs, M, N, p);
   [cBrown, t] = mfcc(sBrown, fs, M, N, p);
   [cWhite, t] = mfcc(sWhite, fs, M, N, p);

   output = [c(1:q,:)'; cPink(1:q,:)'; ...
             cBrown(1:q,:)'; cWhite(1:q,:)'];

else
   output = c(1:q,:)';
end

end
