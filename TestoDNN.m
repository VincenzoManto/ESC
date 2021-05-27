clear all
warning off

cd 'C:\Users\vincm\Desktop\Vincenzo\Universita\3.2\AI\Progetto\SpiralLast\release'

load('SouthSpiralPat_ESC_data.mat','DATA');

label=DATA{2};
label = label(1:400);
myLabels = label.';


Pattern=DATA{1};

rng("default")





foldData = normalize(Pattern(1:400,:),'range');


c = cvpartition(label,"Holdout",0.20);
 
indiciTR = training(c);
indiciTE = test(c);



classifierType = "nn"



%mdl = fscnca(foldData(:,:), myLabels(:),'Solver','sgd','Standardize',true,"Lambda",0);

%save("ncann","mdl")
load("ncann")
features = 4200;  %1610
dataTR.feature = foldData(indiciTR,:);
dataTR.label = myLabels(indiciTR);
dataTE.feature = foldData(indiciTE,:);
dataTE.label = myLabels(indiciTE);
numberOfFeatures = features;
[sortedX, sortedInds] = sort(mdl.FeatureWeights(:),'descend');
selidx = sortedInds(1:numberOfFeatures); 

dataTR.feature = dataTR.feature(:,selidx);
dataTE.feature = dataTE.feature(:,selidx);


classifier.Classifier = fitcnet(dataTR.feature,dataTR.label,...
"Standardize",true,'LayerSizes',[80],'Activations',"none",'Lambda',0.00075,....
'IterationLimit',105);

predicted = predict(classifier.Classifier,dataTE.feature);

confusionchart(dataTE.label,predicted);

accuracy = sum(predicted == dataTE.label) / length(dataTE.label)


