function [centroid, dmin, dmin_value, distortion] = LBG(s, InitialCentroid,...
                                                    distortionThreshold)
%%
%LBG algorithm
%s-input signal
%initial_centroid-matrix of centroids got from training progress
%distortionThreshold-Maximum variance between the initial centroids and the
%                    centroids calculated from this function
%centroid-calculated centroids of input signal s
%dmin-centroid membership
%distortion-total distorsion of each centroid

%%
% default value
if ~exist('thres_distortion', 'var') || isempty(thres_distortion)
    distortionThreshold = 0.05;
end

distortion0=0; %initial distortion of InitialCentroid

%find the nearst centroid for each point in the input signal
L1=size(s,1); L2=size(InitialCentroid,1);K = size(InitialCentroid, 1); 
dmin=zeros(L1,1); d = zeros(L1, L2);
while 1
for i = 1:L2
        d = sum(abs(bsxfun(@minus, s, InitialCentroid(i,:))),2);
end
    [dmin_value, dmin] = min(d, [], 2);
    
%find new centroids for the input signal
centroid=zeros(L2,size(s,2));
for i=1:L2
    n = find(dmin == i);
    centroid(i,:) = mean(s(n,:));
end

%distortion calculation
for i = 1:K
    diff = bsxfun(@minus, s(n, :), centroid(i,:));
    distortion = distortion0 + sum(diff.^2, 'all');
end
distortion = distortion ./ size(s, 1);

%compare distortion
distortionr = abs((distortion-distortion0)./distortion);
if distortionr<distortionThreshold %if distortion of the calculated centroid 
   fprintf("LBG complete");        %of the input signal satisfies the condition,
   break                           %end the loop   
else
    distortion0=distortion; %Otherwise, calculate centroids again
end
end
end


