function [valueSignum,valueLower,valueUpper] = convertToDecimalValue(bitSignum,bitLower,bitUpper)
% This function converts the extracted bits into decimal value
%
%   [valueSignum,valueLower,valueUpper] = convertToDecimalValue(...
%                                                          bitSignum,...
%                                                          bitLower,...
%                                                          bitUpper)
%
%   takes the 3 vectors of bits representing Signum, Lower and Upper
%   signals as Input and gives one value for each as Output
%
% Input:    bitSignum:                      [1x9 double]
%
%           bitLower:                       [1x9 double]
%
%           bitUpper:                       [1x9 double]
%
% Output:   valueSignum:                    [1x1 double]
%
%           valueLower:                     [1x1 double]
%
%           valueUpper:                     [1x1 double]
%
%

% Initiliaze the 3 values Output
valueSignum = 0;
valueLower = 0;
valueUpper = 0;

% Loop over the 9 bits for each vector
for nBit = 1:9
    
    valueSignum = valueSignum + bitSignum(nBit) * 2^(9-nBit);
    
    valueLower = valueLower + bitLower(nBit) * 2^(9-nBit);
    
    valueUpper = valueUpper + bitUpper(nBit) * 2^(9-nBit);
    
end