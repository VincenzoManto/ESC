clear all
warning off

cd 'C:\Users\vincm\Desktop\Vincenzo\Universita\3.2\AI\Progetto\SpiralLast\release'

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

%save("ncann","mdl")
load("ncann")
features = 1610;  %1610
dataTR.feature = foldData(indiciTR,:);
dataTE.feature = foldData(indiciTE,:);
dataTE.label = myLabels(indiciTE);
dataTR.label = myLabels(indiciTR);

numberOfFeatures = features;
[sortedX, sortedInds] = sort(mdl.FeatureWeights(:),'descend');
selidx = sortedInds(1:numberOfFeatures); 
foldData = foldData(:,selidx);
foldData = [foldData myLabels];
csvwrite("t.txt",foldData);



offset = 1;
k = 1;
classifier = {};
affidabilita = [];

offset = 1;
%{
while offset <= 14592

    dataTR.feature = foldData(indiciTR,offset:offset + 768);
    dataTE.feature = foldData(indiciTE,offset:offset + 768);



    classifier{k} = fitcnet(dataTR.feature,dataTR.label,...
        'Standardize',true,'LayerSizes',[80],"Activation","sigmoid","Lambda",0.00075,'IterationLimit',111);
    pp = predict(classifier{k},dataTE.feature);
    %indx = find(((dataTE.label ~= offset) || (dataTE.label ~= offset + 1)));
    labels = dataTE.label;
    %labels(indx) = -1;
    affidabilita(k) = sum(pp == labels) / length(dataTE.label)
    offset = offset + 768;
    k = k + 1;
end 
%}
%save("nnensemble","classifier")
load("nnensemble")
%load("aff")
P = [];

for j = 1:length(dataTE.label)
    predicted = [];
    offset = 1;
    for i = 1:length(classifier)
        features = foldData(indiciTE,offset:offset + 768);
        features = features(j,:);
        predicted(i) = predict(classifier{i},features);
        offset = offset + 768;
    end
    predicted = predicted(predicted > 0);
    if isempty(predicted)       
        P(j) = -1;
        continue;
    end
    bins = min(predicted):max(predicted)';
    h = histcounts(predicted,[bins,Inf]);
    for k = 1:length(h)
       h(k) = h(k) * 1;% affidabilita(bins(k));
    end
    [x,in] = sort(h,'descend');
    bins(in(1));
    P(j) = bins(in(1));
end

confusionchart(dataTE.label,P');

accuracy = sum(P' == dataTE.label) / length(dataTE.label)



 

