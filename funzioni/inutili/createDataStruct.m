function datasetStruct = createDataStruct(pathToData)
% This function create a Dataset Struct to easly manipolate the data
%
%   datasetStruct = createDataStruct(pathToData)
%
%   takes the pathToData as Input and gives the Dataset Struct as Output
%
% Input:    pathToData                     [1x1 String]
%
% Output:   datasetStruct                  [1x1 Struct]
%
% This Struct contains the following fields:
%
%           - filename:                    [1x1 String]
%           The name of the sound File
%
%           - fold:                        [1x1 double]
%           The folder in which is contained the sound File
%
%           - target:                      [1x1 double]
%           The target which is the sound File
%
%           - category:                    [1x1 String]
%           The category of the sound File
%
%           - data:                        [1x double]
%
%


% Create an DelimitedTextImportOptions based on the file.csv
opts = detectImportOptions(pathToData);

% Create a table which contains: - sound File name
%                                - folder
%                                - target
%                                - category
tableDataMatrix = readtable(pathToData,opts);
tableDataMatrix.src_file = [];
tableDataMatrix.take = [];
tableDataMatrix.esc10 = [];

% Create variables to easly loop over each sound File
dataFilename = tableDataMatrix.filename;
dataFolder = tableDataMatrix.fold;
dataTarget = tableDataMatrix.target;
dataCat = tableDataMatrix.category;

% Folder in which are contained the sound Files .wav
wavFiles = dir(fullfile(...
                    'C:\Users\matpa\Documents\TESI\ESC_50\audio','*.wav'));

% Create the dataset Struct
for nRowTable = 1:length(dataFilename)
   
    % Insert filename into the Struct
    datasetStruct(nRowTable).filename = dataFilename(nRowTable);

    % Insert filename into the Struct
    datasetStruct(nRowTable).folder = dataFolder(nRowTable);
    
    % Insert filename into the Struct
    datasetStruct(nRowTable).target = dataTarget(nRowTable);
    
    % Insert filename into the Struct
    datasetStruct(nRowTable).category = dataCat(nRowTable);
    
    % Insert the sound data
    filepath = char(fullfile(wavFiles(nRowTable).folder,...
        dataFilename(nRowTable)));
    dataStruct = importdata(filepath);
    
    datasetStruct(nRowTable).data = dataStruct.data;
    
end