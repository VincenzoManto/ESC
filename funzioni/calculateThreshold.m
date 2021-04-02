function threshold = calculateThreshold(soundSignal)
% This function alculates the Threshold
%
%   threshold = calculateThreshold(soundSignal)
%
% Input:    soundSignal:                        [1x double]
%
% Output:   threshold:                          [1x1 double]
%
%

% Threshold Paper
threshold = var(soundSignal)
                           
% Threshold Default Matlab [ == std() ]                           
% threshold = sqrt(1/(length(soundSignal)-1)*...
%                                sum(abs(soundSignal-mean(soundSignal)).^2));
