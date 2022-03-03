% Clustering Experimental Data Set
% Subtractive method 
% subclust is the function in MATLAB to do the subtractive type of
% clustering 
clc
clear all
close all

%% smaller the influence range, smaller the cluster size but more clusters 
%% number of columns show is equal to the number of input/output dasets. for example when having 
%% 2 inputs and 1 output; 3 columns will show up  
%Datset = importdata('Second Random Dataset.xlsx') % Inlcudes labels
% Dataset = xlsread('Second Random Dataset.xlsx'); % excludes labels
Dataset = xlsread('Second Random Dataset.xlsx'); % excludes labels
DatasetM = Dataset(: , 2); % Probably we do not care about the experiment iteration 
% numbers, so just considered the voltage values at the 2nd column 

%% clusterInfluenceRange — Range of influence of the cluster center
% scalar value in the range [0, 1] | vector
% Range of influence of the cluster center for each input and output assuming the 
% data falls within a unit hyperbox, specified as the comma-separated pair consisting 
% of 'ClusterInfluenceRange' one of the following:
% % Scalar value in the range [0 1] — Use the same influence range for all inputs and outputs.
% Vector — Use different influence ranges for each input and output.
% Specifying a smaller range of influence usually creates more and smaller data clusters, producing more fuzzy rules.
% IR stands for: Influence Range 
IR = 0.6;
%% Find Cluster Centers Using Subtractive Clustering
C1 = subclust(Dataset , IR)
% Unlike the C-Means clustering, subclust (subtractive clustering)
% determines the number of clusters based on the Influence Range (IR)
% Each row of C contains one cluster center.

%% Specify Bounds for Subtractive Clustering
% Define minimum and maximum normalization bounds for each data dimension. 
% Use the same bounds for each dimension.
% dataScale = [-0.2 -0.2 -0.2;
    %           1.2  1.2  1.2];
     dataScale = [-0.2, -0.2 ; 1.2,  1.2]; % apparently it should be 2*2 matrix
% Find cluster centers.
C2 = subclust(Dataset , 0.5 , 'DataScale' , dataScale)

%% Specify Options for Subtractive Clustering
% Specify the following clustering options:
% Squash factor of 2.0 - Only find clusters that are far from each other.
% Accept ratio 0.8 - Only accept data points with a strong potential for being cluster centers.
% Reject ratio of 0.7 - Reject data points if they do not have a strong potential for being cluster centers.
% Verbosity flag of 0 - Do not print progress information to the command window.
options = [2.0 0.8 0.7 0];
% Find cluster centers, using a different range of influence for each dimension (input and output) and the specified options.
IRdifferent = [0.5 0.3]
% C3 = subclust(Dataset , IR , [0.5 0.25 0.3] , 'Options' , options)
C3 = subclust(Dataset , IRdifferent , 'Options' , options)

%% Obtain Cluster Influence Range for Each Data Dimension
% Cluster data, returning cluster sigma values, S.
[C4 , S] = subclust(Dataset , 0.5)
% Cluster sigma values indicate the range of influence of the computed cluster centers in each data dimension.

%% Plot 

%% Generate the FIS
% To generate a fuzzy inference system using subtractive clustering, use the genfis command.
% For example, suppose you cluster your data using the following syntax:
clusterInfluenceRange = 0.6
% C = subclust(Dataset , clusterInfluenceRange , 'DataScale' , dataScale , 'Options' , options)
C = subclust(Dataset , clusterInfluenceRange)
% where the first M columns of data correspond to input variables, and the remaining columns correspond to output variables.
% You can generate a fuzzy system using the same training data and subtractive clustering configuration. To do so:
%Configure clustering options.
opt = genfisOptions('SubtractiveClustering') % opt does NOT work in clustering FIS generation 
opt.ClusterInfluenceRange = clusterInfluenceRange 
opt.DataScale = dataScale 
opt.SquashFactor = options(1) 
opt.AcceptRatio = options(2) 
opt.RejectRatio = options(3) 
opt.Verbose = options(4) 
% Extract input and output variable data.
inputData = Dataset(: , 1);
outputData = Dataset(: , 2);
% Generate FIS structure.
%SubtractiveClusteringFIS = genfis(inputData , outputData , opt)

       options = fuzzy.genfis.SubtractiveClusteringOptions('Verbose',true) % this one works 
       SubtractiveClusteringFIS = genfis(inputData,outputData,options)
writeFIS(SubtractiveClusteringFIS , 'SubtractiveClusteringFIS')
% The fuzzy system, fis, contains one fuzzy rule for each cluster, and each input and output 
% variable has one membership function per cluster. You can generate only Sugeno fuzzy 
% systems using subtractive clustering. For more information, see genfis and genfisOptions

%% data — Data set to be clustered
% M-by-N array
% Data to be clustered, specified as an M-by-N array, where M is the number of 
% data points and N is the number of data dimensions.
% clusterInfluenceRange — Range of influence of the cluster center
% scalar value in the range [0, 1] | vector
% Range of influence of the cluster center for each input and output assuming the 
% data falls within a unit hyperbox, specified as the comma-separated pair consisting of 
% 'ClusterInfluenceRange' one of the following:
%Scalar value in the range [0 1] — Use the same influence range for all inputs and outputs.
% Vector — Use different influence ranges for each input and output.
% Specifying a smaller range of influence usually creates more and smaller data clusters,
% producing more fuzzy rules.
% Name-Value Arguments
% Specify optional comma-separated pairs of Name,Value arguments. 
% Name is the argument name and Value is the corresponding value. 
% Name must appear inside quotes. You can specify several name and value pair arguments 
% in any order as Name1,Value1,...,NameN,ValueN.
% Example: 'DataScale','auto'sets the normalizing factors for the input and output signals
% using the minimum and maximum values in the data set to be clustered.
% DataScale — Data scale factors
% 'auto' (default) | 2-by-N array
% Data scale factors for normalizing input and output data into a unit hyperbox,
% specified as the comma-separated pair consisting of 'DataScale' and a 2-by-N array, 
% where N is the total number of inputs and outputs. Each column of DataScale specifies 
% the minimum value in the first row and the maximum value in the second row for the 
% corresponding input or output data set.
%When DataScale is 'auto', the genfis command uses the actual minimum 
% and maximum values in the data to be clustered.
% Options — Clustering options
% vector
% Clustering options, specified as the comma-separated pair consisting of 'Options' and a 
% vector with the following elements:
% Options(1) — Squash factor
% 1.25 (default) | positive scalar
% Squash factor for scaling the range of influence of cluster centers, specified as a positive scalar. 
% A smaller squash factor reduces the potential for outlying points to be considered as part of 
% a cluster, which usually creates more and smaller data clusters.
% Options(2) — Acceptance ratio
% 0.5 (default) | scalar value in the range [0, 1]
% Acceptance ratio, defined as a fraction of the potential of the first cluster center, 
% above which another data point is accepted as a cluster center, specified as a scalar
% value in the range [0, 1]. The acceptance ratio must be greater than the rejection ratio.
% Options(3) — Rejection ratio
% 0.15 (default) | scalar value in the range [0, 1]
% Rejection ratio, defined as a fraction of the potential of the first cluster center, below which 
% another data point is rejected as a cluster center, specified as a scalar value in the range [0, 1]. 
% The rejection ratio must be less than acceptance ratio.
% Options(4) — Information display flag
% false (default) | true
% Information display flag indicating whether to display progress information during clustering,
% specified as one of the following:
% false — Do not display progress information.
% true — Display progress information.
% Output Arguments
% collapse all
% centers — Cluster centers
% J-by-N array
% Cluster centers, returned as a J-by-N array, where J is the number of clusters and N is the number of data dimensions.
% sigma — Range of influence of cluster centers
% N-element row vector
% Range of influence of cluster centers for each data dimension, returned as an N-element 
% row vector. All cluster centers have the same set of sigma values.

%% Subtractuve Algorithm (subclust)
% Subtractive clustering assumes that each data point is a potential cluster center. 
% The algorithm does the following:
% Calculate the likelihood that each data point would define a cluster center, 
% based on the density of surrounding data points.
% Choose the data point with the highest potential to be the first cluster center.
% Remove all data points near the first cluster center. The vicinity is determined 
% using clusterInfluenceRange.
% Choose the remaining point with the highest potential as the next cluster center.
% Repeat steps 3 and 4 until all the data is within the influence range of a cluster center.
% The subtractive clustering method is an extension of the mountain
% clustering method proposed in Ref [2]

%%  SubtractiveClusteringOptions with properties:        
%fuzzy.genfis.SubtractiveClusteringOptions - MATLAB File Help	View code for fuzzy.genfis.SubtractiveClusteringOptions
% fuzzy.genfis.SubtractiveClusteringOptions
 % SubtractiveClusteringOptions - Creates options for subtractive clustering
   %SubtractiveClusteringOptions creates options for clustering with
%   subtractive clustering to be used by GENFIS function. %%
%   Methods:
   %  SubtractiveClusteringOptions - Class constructor 
%   Properties:
   %  ClusterInfluenceRange - Range of influence of a cluster
    % DataScale             - Scaling factors to normalize clustering data
    % SquashFactor          - Scaling factor to determine neighboring cluster points
    % AcceptRatio           - Ratio to accept a point as a cluster center
    % RejectRatio           - Ratio to reject a point as a cluster center
    % Verbose               - Flag to display clustering progress information
    % CustomClusterCenters  - User-specified custom cluster centers
%   The property values can be specified at construction time as
   % name/value pairs. 
%     Example:
   %    Xin = [rand(10,1) 10*rand(10,1)-5];
     %  Xout = rand(10,1);
       %options = fuzzy.genfis.SubtractiveClusteringOptions('Verbose',true);
       %fis = genfis(Xin,Xout,options);
%See also
%genfis, subclust
%Class Details
%Sealed	false
%Construct on load	false
%Constructor Summary
%SubtractiveClusteringOptions	Class constructor 
%Property Summary
%AcceptRatio	Ratio to accept a point as a cluster center 
%ClusterInfluenceRange	Range of influence of a cluster 
%CustomClusterCenters	User-specified custom cluster centers 
%DataScale	Scaling factors to normalize clustering data 
%RejectRatio	Ratio to reject a point as a cluster center 
%SquashFactor	Scaling factor to determine neighboring cluster points 
%Verbose	Flag to display clustering progress information 

