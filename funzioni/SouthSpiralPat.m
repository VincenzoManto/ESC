function featureVector = SpiralPat(rawEnviromentntalSound)
% This function generates the vector containing the features according to the chosen pattern
%
%   [featureVector] = SpiralPat(rawEnviromentntalSound)
%
%   takes as Input the raw enviromental sound and gives the features vector
%   as Output
%
% Input: rawEnvorimentalSound:                      [1x double]
%
% Output: featureVector:                            [1x1536 double]
%
%

% Calculate threshold
threshold = std(rawEnviromentntalSound);

% Calculate the length of the sound to easly loop
lengthRawEnviromentalSound = length(rawEnviromentntalSound);

% Initialize the vectors containing the Signum, Upper and Lower Values
valueSignum = [];
valueLower = [];
valueUpper = [];

% Loop over the raw sound 
step = 25;

counterBlock = 0;
for nBlock = 1:step:(lengthRawEnviromentalSound-(step-1))
    
    % Divide the sound in 25 sized non overlapping blocks 
    block = rawEnviromentntalSound(nBlock:nBlock+(step-1));

    % Reshape the block to a matrix 5x5
    matrixTrasf = matrixTrasformation(block);
    
    % Calculate the differences according to the chosen pattern 
    vectorDiff = createVectorDifference(matrixTrasf);
    
    % Extracts binary features by using signum and ternary functions
    [bitSignum,bitLower,bitUpper] = extractBinaryFeatures(vectorDiff,...
                                                          threshold);
    
    % Converts the extracted bits into decimal value for each block
    counterBlock = counterBlock+1;
    [valueSignum(counterBlock),...
        valueLower(counterBlock),...
        valueUpper(counterBlock)] = convertToDecimalValue(bitSignum,...
                                                    bitLower,...
                                                    bitUpper);
end

% Build histograms
histogramSignum = histcounts(valueSignum,512,'BinLimits',[0, 511]);
histogramLower = histcounts(valueLower,512,'BinLimits',[0, 511]);
histogramUpper = histcounts(valueUpper,512,'BinLimits',[0, 511]);

% Concatenate histograms and obtain the final features vector
featureVector = [histogramSignum histogramLower histogramUpper];



