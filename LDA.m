load('release/SpiralPat_ESC50_data.mat','DATA');

label=DATA{2};

myLabels = label.';

Pattern=DATA{1};

rng("default")



foldData = Pattern;


c = cvpartition(label,"Holdout",0.20);
 
indiciTR = training(c);
indiciTE = test(c);


dataTR.feature = foldData(indiciTR,:);
load("release/selidx");
selidx = selidx(1:800);
dataTR.feature = dataTR.feature(:,selidx);
dataTR.label = myLabels(indiciTR);

dataTE.feature = foldData(indiciTE,:);
dataTE.label = myLabels(indiciTE);

Mdl = fitcdiscr(dataTR.feature,dataTR.label,'discrimType','diagLinear');
[sortedX, sortedInds] = sort(Mdl.DeltaPredictor,'descend');
selidx = sortedInds(1:700); %800 SVM, 4200 NN

dataTR.feature = dataTR.feature(:,selidx);
dataTE.feature = dataTE.feature(:,selidx);

[classifier, accuracy] = trainClassifierSVM(dataTR.feature,dataTR.label,700);


%accuracy

predicted = predict(classifier.Classifier,dataTE.feature);

confusionchart(dataTE.label,predicted);

accuracy = sum(predicted == dataTE.label) / length(dataTE.label)
