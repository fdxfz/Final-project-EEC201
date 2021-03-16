function [dmin_value, dmin] = NearestCentroid(s,InitialCentroid)
%This function shows where the nearest centroid (in initial centroids) for
%each point in the input signal is, and what the minimum distance value is 
%s-input signal
%InitialCentroid-Centroids got from training process
%dmin_value-distance between the point in the input signal and the nearest 
%           centroid
%dmin-which InitialCentroid is closest to this point

%%
%find the nearst centroid for each point in the input signal
L1=max(size(s)); L2=max(size(InitialCentroid));
dmin=zeros(L1,1); d = zeros(L1, L2);
for i = 1:L2
        d = sum(abs(bsxfun(@minus, s, InitialCentroid(i,:))),2);
end
    [dmin_value, dmin] = min(d, [], 2);
end

