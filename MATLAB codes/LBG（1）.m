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
if ~exist('distortionThreshold', 'var') || isempty(distortionThreshold)
    distortionThreshold = 0.03;
end

distortion0=0; %initial distortion of InitialCentroid

%find the nearst centroid for each point in the input signal
L1=size(s,1); L2=size(InitialCentroid,1);K = size(InitialCentroid, 1); 
dmin=zeros(L1,1); d = zeros(L1, L2); r=0; 
centroid = InitialCentroid; prev_centroid = InitialCentroid;
while (1)
    
for i = 1:L2
        d = sum(bsxfun(@minus, s, centroid(i,:)).^2,2);
end
    [dmin_value, dmin] = min(d, [], 2);
    
%find new centroids for the input signal
centroid=zeros(L2,size(s,2));
for i=1:L2
    n1 = find(dmin == i);
    if  isempty(n1) 
      centroid(i,:) = prev_centroid(i,:);
    else
      centroid(i,:) = mean(s(n1,:));  
    end
end

%distortion calculation
for i = 1:K
    n2 = find(dmin == i);
    if ~isempty(n2)
      diff = bsxfun(@minus, s(n2, :), centroid(i,:));
      distortion = distortion0 + sum(diff.^2, 'all');
    end
end
distortion = distortion ./ size(s, 1);

%compare distortion
distortionr = abs((distortion-distortion0)./distortion);
if distortionr<distortionThreshold %if distortion of the calculated centroid 
   fprintf("LBG complete");        %of the input signal satisfies the condition,
   break                           %end the loop   
else
    distortion0=distortion; %Otherwise, calculate centroids again
    prev_centroid = centroid;
end
end
end


