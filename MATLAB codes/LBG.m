function [centroids, dmin, distortion] = LBG(s, InitialCentroid, ...
                                      distortionThreshold, plot_progress)
%% LBG Algorithm:
%   |- Inspired by Run-TMC and Run-DMC
%
%runLBG() performs the LBG Algorithm by performing k-Clustering
%iteratively until a variance/disortion threshold has been met.
%
%K-Clustering: A Vector Quantization Method by classifying m data
%points/observations into K clusters through the nearest mean.
%
% Assumptions:
% Euclidean Distance is used to calculate the Cluster's
% Varaiance/Distortion
%
% Input:
%   s - Input Data Points' Matris (m*f)
%       |- m = Number of Observations/Data Points
%       |- n = Dimension Size of Observation / Number of Features
%   InitialCentroid - Matris (K*n) containing Centroid points
%       |- K = Number of Clusters to Partition
%       |- n = Dimension Size of Cluster Points
%   distortionThreshold - Threshold quantified by how much variance
%       has been reduced between previous centroids and current centroids
%       |- Note: Default has been set to 0.05
%   plot_progress - (From Coursera) Live Demo of K-Clustering Algorithm
%
% Outputs:
%   centroids - [K*n] matris containing K-number of centroids
%               on a n-dimensional space (feature space)
%   dmin - [m*1] matrix containing each centroid membership on m-samples
%   distortion - Total Variance of each centroid's distortion/variance

% Set default value for plot progress
if ~exist('plot_progress', 'var') || isempty(plot_progress)
    plot_progress = false;
end

% Plot the data if we are plotting progress
if plot_progress
    figure;
    hold on;
end

% Set default value for distortion threshold
if ~exist('distortionThreshold', 'var') || isempty(distortionThreshold)
    distortionThreshold = 0.05;
end

% Initialization
K = size(InitialCentroid, 1); % Number of Clusters
centroids = InitialCentroid;
previous_centroids = centroids;
dmin = zeros(size(s, 1), 1);

prev_distortion = 0;

% % Run K-Means
% max_iters = 100;
% for i=1:max_iters

% Run LBG Algorithm
while (1)
    
%     % Output progress for K-Means
%     fprintf('K-Means iteration %d/%d...\n', i, max_iters);
%     if exist('OCTAVE_VERSION')
%         fflush(stdout);
%     end
    
    %fprintf("LBG still be runnin' ...\n");
    if exist('OCTAVE_VERSION')
        fflush(stdout);
    end

    % For each example in X, assign it to the closest centroid
    dmin = findMyHood(s, centroids);
    
    % Optionally, plot progress here
    if plot_progress
        plotProgresskMeans(s, centroids, previous_centroids, dmin, K, i);
        previous_centroids = centroids;
        pause(0.25);
    end
    
    % Given the memberships, compute new centroids
    centroids = GoToMyHood(s, dmin, K);
    
    % LBG Algorithm :
    distortion = ThisTheHouse(s, dmin, centroids);
    compare_distortion = abs( (prev_distortion-distortion) ...
        /distortion);
    %fprintf('My brudders are %d far away \n', distortion);
    if ( compare_distortion < distortionThreshold )
        %fprintf("I'm home brudder :D \n");
        break
    end
    prev_distortion = distortion;

end

% Hold off if we are plotting progress
if plot_progress
    hold off;
end

end

%% findMyHood() Definition
function dmin = findMyHood(s, centroids)
%findMyHood returns the centroid memberships for every example
%
%Inputs:
%   s - [m*n] matrix containing m-samples and n-number of features
%   centroids - [K*n] matrix containing K-number of centroids
%               on a n-dimensional space (feature space)
%Outputs:
%   dmin - [m*1] matrix containing each centroid membership on m-samples
%

    % Set K
    K = size(centroids, 1);
    dmin = zeros(size(s,1), 1);
    distance = zeros(size(s, 1), K);

    for i = 1:K
        diff = bsxfun(@minus, s, centroids(i,:));
        distance(:, i) = sum(diff.^2, 2);
    end

    [dummy dmin] = min(distance, [], 2);
%     % Alternatively:
%     for j = 1:size(X,1)
%        [dummy dmin(j)] = min(distance(j, :));
%     end

end

%% GoToMyHood() defintion
function centroids = GoToMyHood(s, dmin, K)
%GoToMyHood finds the new centroids' location by computing 
%the means of the data points assigned to each centroid.
%
%Inputs:
%   X - [m*n] matrix containing m-samples and n-number of features
%   dmin - [m*1] matrix containing each centroid membership on m-samples
%   K - number of centroids
%Outputs:
%   centroids - [K*n] matrix containing K-number of centroids
%               on a n-dimensional space (feature space)


    % You need to return the following variables correctly.
    centroids = zeros(K, size(s, 2));

    for i = 1:K
        sel = find(dmin == i); % where i ranges from 1 to K
%         if ( isempty(sel) )
%             centroids(i,:) = prev_centroids(i,:);
%             continue
%         end
        centroids(i,:) = mean(s(sel,:));
    end

end

%% ThisTheHouse() Defintion
function distortion = ThisTheHouse(s, dmin, centroids)
%Computes the mean distortion (error) around the cluster assigned
%Inputs:
%   X - [m*n] input matrix containing m-samples and n-number of features
%   dmin - [m*1] matrix containing each centroid membership on m-samples
%   centroids - [K*n] matrix containing K-number of centroids
%               on a n-dimensional space (feature space)
%Outputs:
%   distortion - the mean distance of each cluster's assigned data points

    distortion = 0;
    K = size(centroids, 1);
    for clster = 1:K
        sel = find(dmin == clster);
        diff = bsxfun(@minus, s(sel, :), centroids(clster,:));
        distortion = distortion + sum(diff.^2, 'all');
    end
    distortion = distortion ./ size(s, 1);
end

%% Visualization Plotting Functions
function drawLine(p1, p2, varargin)
%DRAWLINE Draws a line from point p1 to point p2
%   DRAWLINE(p1, p2) Draws a line from point p1 to point p2 and holds the
%   current figure

plot([p1(1) p2(1)], [p1(2) p2(2)], varargin{:});

end

function plotDataPoints(s, dmin, K)
%PLOTDATAPOINTS plots data points in X, coloring them so that those with the same
%index assignments in dmin have the same color
%   PLOTDATAPOINTS(X, dmin, K) plots data points in X, coloring them so that those 
%   with the same index assignments in dmin have the same color

% Create palette
palette = hsv(K + 1);
colors = palette(dmin, :);

% Plot the data
scatter(s(:,1), s(:,2), 15, colors);

end

function plotProgresskMeans(s, centroids, previous, dmin, K, i)
%PLOTPROGRESSKMEANS is a helper function that displays the progress of 
%k-Means as it is running. It is intended for use only with 2D data.
%   PLOTPROGRESSKMEANS(X, centroids, previous, dmin, K, i) plots the data
%   points with colors assigned to each centroid. With the previous
%   centroids, it also plots a line between the previous locations and
%   current locations of the centroids.
%

% Plot the examples
plotDataPoints(s, dmin, K);

% Plot the centroids as black x's
plot(centroids(:,1), centroids(:,2), 's', ...
     'MarkerEdgeColor','k', ...
     'MarkerSize', 10, 'LineWidth', 3);

% Plot the history of the centroids with lines
for j=1:size(centroids,1)
    drawLine(centroids(j, :), previous(j, :));
end

% Title
title(sprintf('Iteration number %d', i))

end