function featuresVectorConc = enviromentalSoundClassification(soundSignal)
% This function extracts the features from enviromental sound signal
%
%   result = enviromentalSoundClassification(soundSignal)
%
%   takes the sound signal as Input and gives the features vector as Output
%
% Input:    soundSignal:                        [1x double]
%
% Output:   result:                             [1x15360 double]
%
%

%Initialize the features matrix 1536x10
features = NaN(1536,10);

% Loop over the multilevel
for nLevel = 1:10  
    % Spiral pattern based feature extraction function
    features(:,nLevel) = SouthSpiralPat(soundSignal);
    
    % Apply 2D M4 pooling to sound signal
    soundSignal = pooling2DM4(soundSignal);

end

% Concatenate the features vector to create a new vector of features
featuresVectorConc = featuresConcatenation(features);

