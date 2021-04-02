function featuresMultiLevel = featuresConcatenation(featuresVector)
% This function concatenates the features vectors of the multiLevel into one vector
%
%   featuresMultiLevel = featuresConcatenation(featuresVector)
%
%   takes the features of each levels with length 1536 as Input and gives
%   as Output a concatenated features vector with length 15360
%
% Input:    featuresVector                     [10x1536 double]
%
% Output:   featuresMultiLevel                 [1x15360 double]

% Loop over each raw of the features vector
for nLevel = 1 : 10
    
    % Concatenate the features vector to create a new vector of features
    featuresMultiLevel((nLevel - 1) * 1536 + 1 :(nLevel * 1536)) = featuresVector(:,nLevel);
     
end