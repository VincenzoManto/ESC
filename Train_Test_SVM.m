clear all
warning off
addpath("funzioni")
%% Parametri

% percorso al file per la lettura del modello di feature selection salvato
pathToNCA = "feature-selection/NCA-SVM";
% percorso al file per la scrittura del classificatore completo addestrato
pathToClassifier = "classifier/SVM";
% numero delle feature in seguito alla selezione
numberOfFeatures = 1900;
% se vero => carica il modello di feature selection senza ricrearlo
loadNCA = true;
% se vero => salva il modello di feature selection
saveNCA = true;
% percorso alle feature
pathToData = "data-set/SouthSpiralPat_ESC_data";
% se vero => salva il classificatore allenato sull'intero ESC-50
saveCompleteClassifier = true;


%% Addestramento e test



% caricamento patterns/labels

load(pathToData,'DATA');

labels=DATA{2};

labels = labels.';

Patterns=DATA{1};

rng("default")

% partizione 80-20 train-test

c = cvpartition(labels,"Holdout",0.20);
 
indiciTR = training(c);
indiciTE = test(c);

% feature selection

if loadNCA
    load(pathToNCA);
else 
    % è stato notato che modellare NCA e procedere successivamente al
    % training del classificatore, inficia le prestazioni di 0.75% circa
    % si consiglia di modellare NCA, salvare il modello (loadNCA = false) e successivamente
    % caricare e allenare il classificatore (loadNCA = true)
    disp("NCA...");
    normalized = normalize(Patterns,"range");
    mdl = fscnca(normalized, labels,'Solver','sgd',"Lambda",0);
    if saveNCA
        save("feature-selection/NCA-SVM","mdl")
    end
end

% ordinamento discendente delle feature secondo i pesi del modello NCA
[sortedX, sortedInds] = sort(mdl.FeatureWeights(:),'descend');
% selezione degli indici delle #n feature più indicative
indexesSelected = sortedInds(1:numberOfFeatures);

% suddivisione train-test

dataTR.feature = Patterns(indiciTR,:);
dataTR.label = labels(indiciTR);

dataTE.feature = Patterns(indiciTE,:);
dataTE.label = labels(indiciTE);

% selezione delle feature secondo gl'indici

dataTR.feature = dataTR.feature(:,indexesSelected);
dataTE.feature = dataTE.feature(:,indexesSelected);

% addestramento
disp("Training...");
classifier = trainClassifierSVM(dataTR.feature,dataTR.label,numberOfFeatures);

% test
disp("Testing...");
predicted = predict(classifier.Classifier,dataTE.feature);

% visualizzazione confusion map

confusionchart(dataTE.label,predicted);

accuracy = sum(predicted == dataTE.label) / length(dataTE.label)

% addestramento sull'intero ESC-50 e salvataggio

if saveCompleteClassifier
    classifier = trainClassifierSVM(Patterns(:,indexesSelected),labels,numberOfFeatures);
    save(pathToClassifier,"classifier");
end


return