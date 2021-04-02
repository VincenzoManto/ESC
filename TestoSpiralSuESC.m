clear all
warning off

cd 'release'
%carica features create nel file EstraggoESCspiral
load('SpiralPat_ESC50_data.mat','DATA');

%estraggo info per lanciare il 5-fold
NF=2;%size(DATA{3},1); %number of folders

DIV=DATA{3};


DIM1=length(DIV) * 0.8;
DIM2=length(DIV);

label=DATA{2};
Pattern=DATA{1};

rng("default")

%load("MDL.mat")
max = 0;
%5-fold
for fold=1:5
    %close all force

    trainPattern=(DIV(fold,1:DIM1));
    testPattern=(DIV(fold,DIM1+1:DIM2));
    labelTrain=label(DIV(fold,1:DIM1));
    labelTest=label(DIV(fold,DIM1+1:DIM2));

    TR=Pattern(trainPattern,:);
    TE=Pattern(testPattern,:);
    
    Perf_accuracy(fold) = 0;
%    max(fold)
    while Perf_accuracy(fold) < 5 %max(fold)

        Mdl = fitcnet(TR,labelTrain,"Standardize",true,"Activation","none","LayerSizes",[120],"Lambda",0.5e-4);

        sub = predict(Mdl,TE);
        
        
        v = sum(sub == labelTest') / length(labelTest);
        %Perf_accuracy(fold) = v;
        
        %{
        figure
        confusionchart(labelTest, sub)
        title("Sub")
        break

        W = Mdl.LayerWeights;
        %}
        Perf_accuracy(fold) = v;
        if v > max
           max = v
        end 


    end
    disp(Perf_accuracy);
%{
    figure
    confusionchart(labelTest, sub)
    title("Sub")
%}  
end

disp(Perf_accuracy);
mean(Perf_accuracy)










