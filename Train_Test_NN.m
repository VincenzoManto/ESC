clear all
warning off

%% Parametri

% percorso al file per la lettura del modello di feature selection salvato
pathToNCA = "feature-selection/NCA-NN";
% percorso al file per la scrittura del classificatore completo addestrato
pathToClassifier = "classifier/NN";
% numero delle feature in seguito alla selezione
numberOfFeatures = 4200;
% se vero => carica il modello di feature selection senza ricrearlo
loadNCA = true;
% se vero => salva il modello di feature selection
saveNCA = false;
% percorso alle feature
pathToData = "data-set/SouthSpiralPat_ESC_data";
% se vero => salva il classificatore allenato sull'intero ESC-50
saveCompleteClassifier = true;

%% Addestramento e test


% caricamento patterns/labels

load(pathToData,'DATA');

label=DATA{2};

labels = label.';


Patterns=DATA{1};

rng("default")

% partizione 80-20 train-test

c = cvpartition(label,"Holdout",0.20);
 
indiciTR = training(c);
indiciTE = test(c);

% feature selection

if loadNCA
    load(pathToNCA);
else 
    disp("NCA...");
    mdl = fscnca(Patterns(:,:), labels(:),'Solver','sgd');
    if saveNCA
        save("feature-selection/NCA-NN","mdl")
    end
end

% ordinamento discendente delle feature secondo i pesi del modello NCA
[sortedX, sortedInds] = sort(mdl.FeatureWeights(:),'descend');
% selezione degli indici delle #n feature più indicative
indexesSelected = sortedInds(1:numberOfFeatures);

% suddivisione train-test

dataTR.feature = Patterns(indiciTR,:);
dataTE.feature = Patterns(indiciTE,:);
dataTE.label = labels(indiciTE);
dataTR.label = labels(indiciTR);

% selezione delle feature secondo gl'indici

dataTR.feature = Patterns(indiciTR,indexesSelected);
dataTE.feature = Patterns(indiciTE,indexesSelected);

% addestramento
disp("Training...");
classifier.Classifier = fitcnet(dataTR.feature,dataTR.label,...
        'Standardize',true,'LayerSizes',[80],"Activation","none","Lambda",0.00075,'IterationLimit',111);

% test
disp("Testing...");
P = predict(classifier.Classifier,dataTE.feature);
accuracy = sum(P == dataTE.label) / length(dataTE.label)

% addestramento sull'intero ESC-50 e salvataggio

if saveCompleteClassifier
    classifier.Classifier = fitcnet(Patterns(:,indexesSelected),labels,...
        'Standardize',true,'LayerSizes',[80],"Activation","none","Lambda",0.00075,'IterationLimit',111);
    save(pathToClassifier,"classifier");
end

return