clear all
warning off

cd 'C:\Users\vincm\Desktop\Vincenzo\Universita\3.2\AI\Progetto\Spiral\release'

load('SpiralPat_ESC50_data.mat','DATA');


NF=2

DIV=DATA{3};


DIM1=length(DIV) * 0.8;
DIM2=length(DIV);

label=DATA{2};

myLabels = label.';

Pattern=DATA{1};

rng("default")



foldData = Pattern;


c = cvpartition(label,"Holdout",0.20);

indiciTR = training(c);
indiciTE = test(c);

dataTR.feature = foldData(indiciTR,:);
dataTR.label = myLabels(indiciTR);

dataTE.feature = foldData(indiciTE,:);
dataTE.label = myLabels(indiciTE);

classifierType = "svm";




% ESC-50 1-fold (153,5e-4,1e-8) = 56.25%
% ESC-10 1-fold (153,1e-8,1e-10,1e-10) = 81.25%

%nca = fscnca(dataTR.feature,dataTR.label,'Solver','sgd','Verbose',1);

%save("nca","nca")
load("nca")

numberOfFeatures = 800;

maxV = max(nca.FeatureWeights);

[sortedX, sortedInds] = sort(nca.FeatureWeights(:),'descend');
selidx = sortedInds(1:numberOfFeatures); %800 SVM, 4200 NN

save("selidxSVM.mat","selidx");
dataTR.feature = dataTR.feature(:,selidx);
dataTE.feature = dataTE.feature(:,selidx);

if classifierType == "ens"
    [classifier, accuracy] = trainClassifierEnsemble(dataTR.feature,dataTR.label,numberOfFeatures);
elseif classifierType == "svm"
    [classifier, accuracy] = trainClassifierSVM(dataTR.feature,dataTR.label,numberOfFeatures);
else
    classifier.Classifier = fitcnet(dataTR.feature,dataTR.label,"Standardize",true,"Activation","none","LayerSizes",[153],"Lambda",1e-3);
end

save("svmClassifier","classifier");
%accuracy

predicted = predict(classifier.Classifier,dataTE.feature);

confusionchart(dataTE.label,predicted);

accuracy = sum(predicted == dataTE.label) / length(dataTE.label)










