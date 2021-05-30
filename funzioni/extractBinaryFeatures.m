function [bitSignum,bitLower,bitUpper] = extractBinaryFeatures(vectorDiff,threshold)
% This function extracts binary features by using signum and ternary functions
%
%   [bitSignum,bitLower,bitUpper] = extractBinaryFeatures(...
%                                                            vectorDiff,...
%                                                            threshold)
%
%   takes as Input a vector containing differences calculated 
%   according to the Spiral pattern and a threshold of the ternary function
%   Gives 3  new signal as Output 
%
% Inputs:   vectorDiff:                     [1x9 double]
%
%           threshold:                      [1x1 double]
%
% Output:   bitSignum:                      [1x9 double]
%
%           bitLower:                       [1x9 double]
%
%           bitUpper:                       [1x9 double]
%
%

% Initialize the 3 vector Output
bitSignum = NaN(1,9);
bitLower = NaN(1,9);
bitUpper = NaN(1,9);


% Loop over the 9 values contained in the vectorDiff
for nBit = 1:9
    
    % bitSignum
    if vectorDiff(nBit) < 0
        
        bitSignum(nBit) = 0;
        
    else
        
        bitSignum(nBit) = 1;
        
    end
    
    % bitLower
    if vectorDiff(nBit) >= -threshold
        
        bitLower(nBit) = 0;
        
    else
        
        bitLower(nBit) = 1;
        
    end
    
    % bitUpper
    if vectorDiff(nBit) <= threshold
        
        bitUpper(nBit) = 0;
        
    else
        
        bitUpper(nBit) = 1;
        
    end
    
end
