clear all
warning off

cd 'C:\Users\vincm\Desktop\Vincenzo\Universita\3.2\AI\Progetto\SpiralLast\release'

load('SouthSpiralPat_ESC_data.mat','DATA');

label=DATA{2};

myLabels = label.';

Pattern=DATA{1};

rng("default")



foldData = normalize(Pattern,'range');


c = cvpartition(label,"Holdout",0.20);
 
indiciTR = training(c);
indiciTE = test(c);



classifierType = "svm"

%mdl = fscnca(foldData(:,:), myLabels(:),'Solver','sgd',"Lambda",0);
%save("ncanormalized","mdl")
load("ncanormalized")

SVMfeatures = [1900];
features = SVMfeatures;

for i = 1:length(features)
    dataTR.feature = foldData(indiciTR,:);
    dataTR.label = myLabels(indiciTR);

    dataTE.feature = foldData(indiciTE,:);
    dataTE.label = myLabels(indiciTE);

    numberOfFeatures = features(i)
    [sortedX, sortedInds] = sort(mdl.FeatureWeights(:),'descend');
    selidx = sortedInds(1:numberOfFeatures);

    dataTR.feature = dataTR.feature(:,selidx);
    dataTE.feature = dataTE.feature(:,selidx);

    classifier = trainClassifierSVM(dataTR.feature,dataTR.label,numberOfFeatures);

    predicted = predict(classifier.Classifier,dataTE.feature);

    confusionchart(dataTE.label,predicted);

    accuracy = sum(predicted == dataTE.label) / length(dataTE.label)
end 


