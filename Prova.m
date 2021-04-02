cd release
%carica features create nel file EstraggoESCspiral
load('SpiralPat_ESC50_data.mat','DATA');

%estraggo info per lanciare il 5-fold
NF=2;%size(DATA{3},1); %number of folders

DIV=DATA{3};
%{
DIM1=DATA{4}

DIM2=DATA{5}
%}


%ESC10 max = [0.7875 0.7 0.825 0.8125 0.7375];
%max = [0.44 0.4 0.46 0.48 0.46];

DIM1=length(DIV) * 0.8;
DIM2=length(DIV);

label=DATA{2};
Pattern=DATA{1};

rng("default")

%load("MDL.mat")
max = 0;
%5-fold
for fold=1:1
    %close all force
layers = [
    
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];


    trainPattern=(DIV(fold,1:DIM1));
    testPattern=(DIV(fold,DIM1+1:DIM2));
    labelTrain=label(DIV(fold,1:DIM1));
    labelTest=label(DIV(fold,DIM1+1:DIM2));

    TR=Pattern(trainPattern,:);
    TE=Pattern(testPattern,:);
    
end