function accuracy = trainModel_FeatsExtraction(numberOfFeaturesSelected, mod)
%% Function Test to reduce the dimensionality and Train and Test the Model

%%%%%%%%%%   Cambiare il nome del File per salvataggio !!!!!

% Paths
pathToNets = 'C:\Users\matpa\Documents\TESI\Nets';
pathToModel = fullfile(pathToNets,'Models');
pathToVariables = fullfile(pathToNets,'Variables');

% Load the features
% file = strcat('Variabili\featuresData_StructData_', mod,'.mat');
file = strcat('featuresData_StructData_', mod,'.mat');
load(file);

disp(mod)
disp(numberOfFeaturesSelected)

% featuresRanked = sortRank(features,idxRank, numberOfFeaturesSelected);
counter = 0;
featuresRanked = features;

%% Divide Train/Test Sets
for iteration = 1:400:2000
    counter = counter+1;
    
    TrainSet = featuresRanked(:,:);
    TrainSet(iteration:iteration+399,:) = [];
    YTrain = Y;
    YTrain(iteration:iteration+399) = [];
    
    TestSet = featuresRanked(iteration:iteration+399,:);
    YTrue = Y(iteration:iteration+399);
    
    %% Create Model
    tic
    disp('Starting Training:...')
    
    %-----------------------------------------%
    %% Function : fscnca
%     modelSVM = fscnca(TrainSet,YTrain,...
%                    'Solver','sgd',...
%                    'Standardize',true,...
%                    'Verbose',1);
%     model = modelSVM; % Per Salvataggio
%     
%     figure(counter)
%     plot(modelSVM.FeatureWeights,'ro')
%     grid on
%     xlabel('Feature index')
%     ylabel('Feature weight')
%     [YPred, ScoresPred] = predict(modelSVM, TestSet);
  
%--------------------------------------------%         
    %% Function : fitecoc
    learnersTemplate = templateSVM('Standardize',true);                          
    options = statset('UseParallel',true);
    
%     model = fitcecoc(TrainSet,YTrain,...
%                      'Learners',learnersTemplate,...
%                      'Options',options);

% TEST
    model = fitcecoc(TrainSet,YTrain,...
                     'Learners',learnersTemplate,...
                     'Options',options);
    
    [YPred, svmScores] = predict(model, TestSet,'ObservationsIn','rows');

%-----------------------------------------%
    %% Function : fitcdiscr
%     model = fitcdiscr(TrainSet,YTrain,'DiscrimType','pseudolinear');

%-----------------------------------------%
    %% Function : pca + fitcecoc
%     learnersTemplate = templateSVM('Standardize',true);                          
%     options = statset('UseParallel',true);
%     
%     [coeffPCA, scorePCA, latentPCA, tSquaredPCA, explainedPCA, muPCA]=...
%                                                              pca(TrainSet);
%     
%     sum_explained = 0;
%     idx = 0;
%     while sum_explained < 95
%         idx = idx + 1;
%         sum_explained = sum_explained + explainedPCA(idx);
%     end
%      
%     scoreTrain95 = scorePCA(:,1:idx);
%     modelPCA_Fitcecoc = fitcecoc(scoreTrain95,YTrain,...
%                    'Options',options,...
%                    'Learners',learnersTemplate);
%     
%     scoreTest95 = (TestSet-muPCA)*coeffPCA(:,1:idx);
%     YPred = predict(modelPCA_Fitcecoc,scoreTest95);
    
    toc
    
    %% Test Model
    %
    if isrow(YPred)
    else
        
        YPred = YPred';
    end
    %
    
    disp('Testing Model:...')

    accuracyFold(counter) = sum(YPred == YTrue)/length(YTrue);
    accuracyString = sprintf('Accuracy: %s',num2str(accuracyFold(counter)));
    disp(accuracyString)
    
    %% Save Variables
    prediction.TrainSet = TrainSet;
    prediction.YTrain = YTrain;
    prediction.TestSet = TestSet;
    prediction.YTrue = YTrue;
    prediction.Score = svmScores;
    
    nameModel = strcat('fitcecoc_',mod,'_Base_Iter_',...
                        int2str(iteration),'_',...
                        int2str(numberOfFeaturesSelected),'_Feats.mat');
    nameVariables = strcat('fitcecoc_',mod,'_Base_Iter_',...
                           int2str(iteration),'_',...
                           int2str(numberOfFeaturesSelected),'_Feats.mat');
                       
    fileModelName = fullfile(pathToModel,nameModel);
    fileVariablesName = fullfile(pathToVariables,nameVariables);
    
%     save(fileModelName,'model');
%     save(fileVariablesName,'prediction');
    
    % Confusion Matrix
    fig = figure(counter);
    cm = confusionchart(YTrue,YPred,...
                        'RowSummary','row-normalized',...
                        'ColumnSummary','column-normalized');
    fig_Position = fig.Position;
    fig_Position(3) = fig_Position(3)*1.5;
    fig.Position = fig_Position;
    
    disp('---------------------------------------------------------------')
end

accuracy = sum(accuracyFold)/length(accuracyFold);
