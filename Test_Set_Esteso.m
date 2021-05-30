%% Parametri
% i classificatori addestrati sono SVM che richiede 1900 feature e NN che richiede 4200
classifierType = "SVM";
numberOfFeatures = 1900;
pathToClassifier = "classifier/" + classifierType;
pathToNCA = "feature-selection/NCA-SVM";


%% Test

predicteds = {};

% caricamento degli indici delle #n feature

load(pathToNCA);
[sortedX, sortedInds] = sort(mdl.FeatureWeights(:),'descend');
indexesSelected = sortedInds(1:numberOfFeatures);

% caricamento del classificatore

load(pathToClassifier);

% caricamento dei nomi estesi delle classi

load("info-classes/nomi-classi");

real = {};

% caricamento audio
d=dir('../EXT'); % directory dove avete salvato il dataset
d(ismember( {d.name}, {'.', '..'})) = [];  
cd ../EXT
pattern=dir('*.mp3');

% test

correct = 0;
total = 1;
for num=1:length(pattern)

    % estrazione del segnale audio

    [Y{1}, FS{1}]=audioread(pattern(num).name);
    name = pattern(num).name;

    % feature extraction mediante Pattern

    spe = enviromentalSoundClassification(Y{1});
    
    % selezione delle #n feature

    spe = spe(:,indexesSelected);
    
    name = strsplit(name,"-");
    name = name{1};

    % classificazione

    predicted = predict(classifier.Classifier,spe);
    predicteds = [predicteds, nm(predicted)];
    real = [real, name];

    % check

    if (nm(predicted) + "") == name
        correct = correct + 1;
        percentage = round(correct / total * 100,2);
        fprintf(1,nm(predicted) + "\t\t" + name + "\t\t" + percentage + "%%\n");
    else 
        percentage = round(correct / total * 100,2);
        fprintf(2,nm(predicted) + "\t\t" + name + "\t\t" + percentage + "%%\n" );
    end
    total = total + 1;
end

% visualizzazione

confusionchart(real,predicteds);
accuracy = correct / length(pattern)
