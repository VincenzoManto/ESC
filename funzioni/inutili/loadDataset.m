function datasetStruct = loadDataset()
% This function load the dataset in a Struct
%
%   datasetStruct = loadDataset()
%
% Output : datasetStruc:                    [1x Struct]
%
%
% This Struct contain the following fields:
%   
%           - name:                         [1x1 String]
%           The name of the sound File
%
%           - data:                         [1x double]
%           The data of the raw sound
%
%           - frequency:                    [1x1 int]
%           The frequency at which the sound was recorded
%
%


% aaaaaaaa
wavFiles = dir(fullfile(...
                       '/Users/Matteo/Desktop/TESI/ESC_50/audio'));
                   
% Calculate the number of sounf Files in the folder
nWavFiles = numel(wavFiles);

% Loop over every sound File
for wavFile = 1:nWavFiles

    filename = fullfile(wavFiles(wavFile).folder,...
        wavFiles(wavFile).name);
    
    dataStruct = importdata(filename);

    datasetStruct(wavFile).name = wavFiles(wavFile).name;
    datasetStruct(wavFile).data = dataStruct.data;
    datasetStruct(wavFile).frequency = dataStruct.fs;

end