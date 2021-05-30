%% Parametri

% numero di registrazioni consecutive
numberOfSounds = 10;
% caricamento del classificatore
pathToClassifier = "classifier/SVM";
pathToNCA = "feature-selection/NCA-SVM";
numberOfFeatures = 1900;

%% Test

% caricamento degli indici delle #n feature

load(pathToNCA);
[sortedX, sortedInds] = sort(mdl.FeatureWeights(:),'descend');
indexesSelected = sortedInds(1:numberOfFeatures);


% caricamento label testuali delle classi e classificatore

load("info-classes/nomi-classi");
load(pathToClassifier);

labels = [];

for i = 1:numberOfSounds

    % registrazione 

    recObj = audiorecorder(48000,16,1);

    % inizio registrazione

    disp('Inizio')

    % 5s di durata 

    recordblocking(recObj, 5);
    
    % fine registrazione

    disp('Stop');

    % lettura del segnale

    y = getaudiodata(recObj);

    % creazione feature vector

    spe = enviromentalSoundClassification(y);
    
    spe = spe(:,indexesSelected);

    % classificazione

    label = predict(classifier.Classifier,spe);
    labels = [labels, nm(label)];
    
    disp("Predetto: " + nm(predicted));
end

