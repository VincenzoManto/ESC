clear all
warning off

cd 'C:\Users\vincm\Desktop\Vincenzo\Universita\3.2\AI\Progetto\Spiral\release'
%carica features create nel file EstraggoESCspiral
load('SpiralPat_ESC50_data.mat','DATA');

%estraggo info per lanciare il 5-fold
NF=2;%size(DATA{3},1); %number of folders

DIV=DATA{3};


DIM1=length(DIV) * 0.8;
DIM2=length(DIV);

label=DATA{2};

myLabels = label.';

Pattern=DATA{1};

rng("default")



foldData = Pattern;

%foldData = foldData.';

c = cvpartition(label,"Holdout",0.20);

indiciTR = training(c);
indiciTE = test(c);

dataTR.feature = foldData(indiciTR,:);
dataTR.label = myLabels(indiciTR);

dataTE.feature = foldData(indiciTE,:);
dataTE.label = myLabels(indiciTE);





% ESC-50 1-fold (153,5e-4,1e-8) = 56.25%
% ESC-10 1-fold (153,1e-8,1e-10,1e-10) = 81.25%

%{

TBL{1} = dataTE.feature;
TBL{2} = dataTE.label;

Mdl = fitcnet(dataTR.feature,dataTR.label,"Standardize",true,"Activation","none","LayerSizes",[153],"Lambda",1e-3);

iteration = Mdl.TrainingHistory.Iteration;
trainLosses = Mdl.TrainingHistory.TrainingLoss;
valLosses = Mdl.TrainingHistory.ValidationLoss;

plot(iteration,trainLosses,iteration,valLosses)
legend(["Training","Validation"])
xlabel("Iteration")
ylabel("Cross-Entropy Loss")

testAccuracy = 1 - loss(Mdl,dataTE.feature,dataTE.label,"LossFun","classiferror")

%confusionchart(dataTE.label,predict(Mdl,dataTE.feature))


%}
%mdl = fscnca(dataTR.feature,dataTR.label,'Solver','sgd','Verbose',1);
tol    = 0.001;
 %save("nca","mdl")
load("nca")

numberOfFeatures = 4200;

maxV = max(mdl.FeatureWeights);
%selidx = find(mdl.FeatureWeights > tol*maxV);
[sortedX, sortedInds] = sort(mdl.FeatureWeights(:),'descend');
selidx = sortedInds(1:numberOfFeatures); %800 SVM, 4200 NN

save("selidx.mat","selidx");

dataTR.feature = dataTR.feature(:,selidx);
dataTE.feature = dataTE.feature(:,selidx);

%[classifier, accuracy] = trainClassifierEnsemble(dataTR.feature,dataTR.label,numberOfFeatures);

%[classifier, accuracy] = trainClassifierSVM(dataTR.feature,dataTR.label,numberOfFeatures);

classifier.Classifier = fitcnet(dataTR.feature,dataTR.label,"Standardize",true,"Activation","none","LayerSizes",[153],"Lambda",1e-3);
save("lastClassifier","classifier");
%accuracy

predicted = predict(classifier.Classifier,dataTE.feature);

%testAccuracy = 1 - loss(classifier,dataTE.feature,dataTE.label,"LossFun","classiferror")
accuracy = sum(predicted == dataTE.label) / length(dataTE.label)










