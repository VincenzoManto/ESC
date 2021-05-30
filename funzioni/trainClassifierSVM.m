function trainedClassifier = trainClassifierSVM(trainingData, responseData,features)
% Ritorna un classificatore addestrato. 
%  Input:
%      trainingData: Dati delle features relativi ai pattern
%
%      responseData: Vettore delle label per il training supervisionato.
%        Il numero di righe deve essere pari al numero di righe del training-set
%
%  Output:
%      trainedClassifier: Struct contentente il classificatore addestrato. 
%       La struct contiene differenti campi informativi del classificatore
%       FitECOC
%
%      trainedClassifier.predictFcn: Una funzione che permette di fare agevolmente
%        classificazioni future

predictorNames = {};
for x = 1:features
    predictorNames = [predictorNames, (x + "")];
    
end

inputTable = array2table(trainingData, 'VariableNames', predictorNames);

predictors = inputTable(:, predictorNames);
response = responseData;

% Addestramento classificatore

% le classi sono scritte in maniera estesa (si può evitare)

template = templateSVM(...
    'GapTolerance',5e-1,...
    'IterationLimit',1e8,...
    'Standardize', true);

classificationSVM = fitcecoc(...
    predictors, ...
    response, ...
    'FitPosterior',true,...
    'Learners', template, ...
    'ClassNames', [1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 17; 18; 19; 20; 21; 22; 23; 24; 25; 26; 27; 28; 29; 30; 31; 32; 33; 34; 35; 36; 37; 38; 39; 40; 41; 42; 43; 44; 45; 46; 47; 48; 49; 50]);


% crea la funzione di predizione
predictorExtractionFcn = @(x) array2table(x, 'VariableNames', predictorNames);
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% ritorna il classificatore
trainedClassifier.Classifier = classificationSVM;

