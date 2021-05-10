clear all
warning off

cd 'C:\Users\vincm\Desktop\Vincenzo\Universita\3.2\AI\Progetto\Spiral\release'

load('SpiralPat_ESC50_data.mat','DATA');

label=DATA{2};

myLabels = label.';

Pattern=DATA{1};

rng("default")



foldData = Pattern;


c = cvpartition(label,"Holdout",0.20);
 
indiciTR = training(c);
indiciTE = test(c);



classifierType = "dnn"



%mdl = fscnca(foldData(:,:), myLabels(:),'Solver','sgd');

%save("nca","nca")
load("nca")

%1980 1982
features = [4200];

for i = 1:length(features)
dataTR.feature = foldData(indiciTR,:);
dataTR.label = myLabels(indiciTR);

dataTE.feature = foldData(indiciTE,:);
dataTE.label = myLabels(indiciTE);

numberOfFeatures = features(i)
[sortedX, sortedInds] = sort(mdl.FeatureWeights(:),'descend');
selidx = sortedInds(1:numberOfFeatures); %800 SVM, 4200 NN

%save("selidxSVM.mat","selidx");
dataTR.feature = dataTR.feature(:,selidx);
dataTE.feature = dataTE.feature(:,selidx);

if classifierType == "ens"
    [classifier, accuracy] = trainClassifierEnsemble(dataTR.feature,dataTR.label,numberOfFeatures);
elseif classifierType == "svm"
    [classifier, accuracy] = trainClassifierSVM(dataTR.feature,dataTR.label,numberOfFeatures);
elseif classifierType == "nn"
    classifier.Classifier = fitcnet(dataTR.feature,dataTR.label,...
        'Verbose',1,...
        "Standardize",true,'LayerSizes',[50],'Activations',"none",'Lambda',0.00075,....
        'IterationLimit',111);
elseif classifierType == "dnn"
    v = cvpartition(dataTR.label,"Holdout",0.20);
 
    vTR = training(v);
    vTE = test(v);
    V{1} = dataTR.feature(vTE,:);
    V{2} = categorical(dataTR.label(vTE,:));
    layers = [...
            featureInputLayer(4200,"Name","featureinput","Normalization","rescale-zero-one")
            fullyConnectedLayer(50,"Name","fc_2")
            fullyConnectedLayer(50,"Name","fc_2")
            softmaxLayer("Name","softmax")
            classificationLayer("Name","classoutput")];
    options = trainingOptions('sgdm', ...
        'Verbose',false, ...
        'InitialLearnRate',0.01, ...
        'Shuffle','every-epoch', ...
        'ValidationData',V, ...
        'ValidationFrequency',10, ...
        'Plots','training-progress');

    net = trainNetwork(dataTR.feature(vTR,:),categorical(dataTR.label(vTR,:)),layers,options);
    
    predicted = classify(net,dataTE.feature);
    s= string(predicted);
    predicted = double(s);
    accuracy = sum(predicted == dataTE.label) / length(dataTE.label)
    confusionchart(dataTE.label,predicted);
    return
end

%save("svmClassifier","classifier");
%accuracy

predicted = predict(classifier.Classifier,dataTE.feature);

confusionchart(dataTE.label,predicted);

accuracy = sum(predicted == dataTE.label) / length(dataTE.label)
accuracies(i) = accuracy;
end 










