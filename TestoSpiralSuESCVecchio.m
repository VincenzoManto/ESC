clear all
warning off

cd 'C:\Users\vincm\Desktop\Vincenzo\Universita\3.2\AI\Progetto\Spiral\release'

load('SouthSpiralPat_ESC_data.mat','DATA');

label=DATA{2};

myLabels = label.';

Pattern=DATA{1};

rng("default")



foldData = Pattern;


c = cvpartition(label,"Holdout",0.20);
 
indiciTR = training(c);
indiciTE = test(c);



classifierType = "nn"



%mdl = fscnca(foldData(:,:), myLabels(:),'Solver','sgd','Standardize',true,"Lambda",0);

%save("ncaSouth","mdl")
%load("ncaSouth")
load("nca1805nn")

%1980 1982
SVMfeatures = [1050 1060 1070]; % 2785 -> 56.75%
%SVMfeatures = [750 800 850 900 950]; 

features = SVMfeatures;

for i = 1:length(features)
dataTR.feature = foldData(indiciTR,:);
dataTR.label = myLabels(indiciTR);

dataTE.feature = foldData(indiciTE,:);
dataTE.label = myLabels(indiciTE);

numberOfFeatures = features(i)
[sortedX, sortedInds] = sort(mdl.FeatureWeights(:),'descend');
selidx = sortedInds(1:numberOfFeatures); %800 SVM, 4200 NN

dataTR.feature = dataTR.feature(:,selidx);
dataTE.feature = dataTE.feature(:,selidx);

if classifierType == "ens"
    % 800 -> 51%
    [classifier, accuracy] = trainClassifierEnsemble(dataTR.feature,dataTR.label,numberOfFeatures);
elseif classifierType == "svm"
    % 1100 -> 57%
    % 2420 -> 56.5%
    classifier = trainClassifierSVM(dataTR.feature,dataTR.label,numberOfFeatures);
elseif classifierType == "nn"
    % 4200 -> 54.5%
    % 1610 -> 56%
    classifier.Classifier = fitcnet(dataTR.feature,dataTR.label,...
        "Standardize",true,'LayerSizes',[50],'Activations',"none",'Lambda',0.00075,....
        'IterationLimit',111);
end

%save("svmClassifier","classifier");
%accuracy

predicted = predict(classifier.Classifier,dataTE.feature);

confusionchart(dataTE.label,predicted);

accuracy = sum(predicted == dataTE.label) / length(dataTE.label)
accuracies(i) = accuracy;
end 


