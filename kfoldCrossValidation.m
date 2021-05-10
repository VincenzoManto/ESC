 clear all
warning off

cd 'C:\Users\vincm\Desktop\Vincenzo\Universita\3.2\AI\Progetto\Spiral\release'

load('SpiralPat_ESC50_data.mat','DATA');





label=DATA{2};

myLabels = label.';

Pattern=DATA{1};

rng("default")



foldData = Pattern;

NF=size(DATA{3},1); %number of folders

DIV=DATA{3};

DIM1=DATA{4};

DIM2=DATA{5};

label=DATA{2};
Pattern=DATA{1};

close all force
    
    %trainPattern=(DIV(fold,1:DIM1))';
    %testPattern=(DIV(fold,DIM1+1:DIM2))';

    %{
    labelTrain=label(DIV(fold,1:DIM1));
    labelTest=label(DIV(fold,DIM1+1:DIM2));
    %}
    
    %c = cvpartition(label,"Holdout",0.20);
    c = cvpartition(label,"KFold",5);
 
 for i = 1:c.NumTestSets
    indiciTR = c.training(i);
    indiciTE = c.test(i);

    %indiciTR = trainPattern;
    %indiciTE = testPattern;
    
    labels = label.';

    TR = Pattern(indiciTR,:);
    labelTrain = labels(indiciTR);

    TE = Pattern(indiciTE,:);
    labelTest = labels(indiciTE);

    nca = fscnca(Pattern,labels,'Solver','sgd');

    numberOfFeatures = 200;


    [sortedX, sortedInds] = sort(nca.FeatureWeights(:),'descend');
    selidx = sortedInds(1:numberOfFeatures); %800 SVM, 4200 NN
    
    load("release/selidxSVM");
    
    TR = TR(:,selidx);
    TE = TE(:,selidx);


    [classifier, accuracy] = trainClassifierSVM(TR,labelTrain,numberOfFeatures);
    
    %save("svmClassifierFold","classifier");
    predicted = predict(classifier.Classifier,TE);

    confusionchart(labelTest,predicted);

    accuracy = sum(predicted == labelTest) / length(labelTest)
    
    
    
end









