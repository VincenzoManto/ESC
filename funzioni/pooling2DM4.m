function outputSignal = pooling2DM4(soundSignal)
% This function uses a multi-statistical moments based pooling method called as 2D-M4 pooling method. 16 statistical moments are used to reduce size of the input
%
%   outputSignal = function2DM4(rawEnviromentalSound)
%
%   takes the raw enviromental sound with length L as Input and gives 
%   as Output a new signal with length L/2
%
% Input: rawEnviromentalSound:                  [1x double]
%
% Output: outputSignal:                         [1x double]
%
%

% Counter defining
counter = 1;

%Initialize the vector of the 16 statistical features 
statisticalFeatures = NaN(1,16);

% Calculate the length of the sound to easly loop
lengthEnviromentalSound = length(soundSignal);

%
for nBlock = 1:32:(lengthEnviromentalSound - 31)
    
    
    % Divide the sound in 32 sized non-overlapping blocks  
    block = soundSignal(nBlock:nBlock + 31);
    % Reshape the vector in a 4x8 matrix
    block = reshape(block,[4,8]);
    
    % Apply multi-statistical moments based pooling method
    statisticalFeatures(1) = min(min(block));
    statisticalFeatures(2) = min(max(block));
    statisticalFeatures(3) = min(median(block));
    statisticalFeatures(4) = min(mean(block));
    statisticalFeatures(5) = max(min(block));
    statisticalFeatures(6) = max(max(block));
    statisticalFeatures(7) = max(median(block));
    statisticalFeatures(8) = max(mean(block));
    statisticalFeatures(9) = mean(min(block));
    statisticalFeatures(10) = mean(max(block));
    statisticalFeatures(11) = mean(median(block));
    statisticalFeatures(12) = mean(mean(block));
    statisticalFeatures(13) = median(min(block));
    statisticalFeatures(14) = median(max(block));
    statisticalFeatures(15) = median(median(block));
    statisticalFeatures(16) = median(mean(block));
    
    % Insert the statistical features into the new output signal
    outputSignal(counter:counter + 15) = statisticalFeatures;
    
    % Update the counter
    counter = counter + 16;

end
