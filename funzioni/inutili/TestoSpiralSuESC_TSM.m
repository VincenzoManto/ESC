clear all
warning off

load('D:\c\Lavoro\Implementazioni\MusicGenre\Spiral\SpiralPat_ESC_TSM.mat','DATA');

NF=size(DATA{3},1); %number of folds
DIV=DATA{3};
DIM1=DATA{4};
DIM2=DATA{5};
yE=DATA{2};
NX=DATA{1};
DA=DATA{4};

NXa=DATA{6};
NXb=DATA{7};

for fold=1:NF
    close all force
    
    trainPattern=(DIV(fold,1:DIM1));
    testPattern=(DIV(fold,DIM1+1:DIM2));
    y=yE(DIV(fold,1:DIM1));
    yBase=y;
    yy=yE(DIV(fold,DIM1+1:DIM2));
    
    %segnali originali
    TR=NX(trainPattern,:);
    TE=NX(testPattern,:);
    tmp=size(TR,1)+1;
    tmpTE=size(TE,1)+1;
    TR(17600,:)=0;
    TE(4400,:)=0;
    for posaADD=1:5 %aggiungo i due set di 5 pose aggiuntive
        for pat=1:length(trainPattern)
            TR(tmp,:)= NXa{posaADD}{trainPattern(pat)};
            tmp=tmp+1;
        end
        y=[y yBase];
        
        for pat=1:length(trainPattern)
            try
                TR(tmp,:)= NXb{posaADD}{trainPattern(pat)};
            catch
            end
            tmp=tmp+1;
        end
        y=[y yBase];
         
        for pat=1:length(testPattern)
            TE(tmpTE,:)= NXa{posaADD}{testPattern(pat)};
            qualeOR(tmpTE)=pat;
            tmpTE=tmpTE+1;
            try
            TE(tmpTE,:)= NXb{posaADD}{testPattern(pat)};
            catch
            end
            qualeOR(tmpTE)=pat;
            tmpTE=tmpTE+1;
        end
        
    end
    
    numClasses = max(y);
    
    zeros=find(sum(TR)==0);
    TR(:,zeros)=[];
    TE(:,zeros)=[];
    
    idx = fscchi2(TR,y);
    TR=TR(:,idx(1:5000));
    TE=TE(:,idx(1:5000));
    
    learnersTemplate = templateSVM('Standardize',true);
    options = statset('UseParallel',true);
    Mdl = fitcecoc(TR,y,...
        'Learners',learnersTemplate,...
        'Options',options);
    [presunteLab,svm_scores]=predict(Mdl,TE, 'ObservationsIn', 'rows');
    
    %sum rule fra pose aggiuntive del test set
    clear scoreSUM
    scoreSUM=[];
    for img=1:length(yy)
        scoreSUM(img,:)=max([svm_scores(img,:); svm_scores(find(qualeOR==img),:)]);
    end
    [a,b]=max(scoreSUM');
    Perf(fold,1)=sum(b==yy)/400
    
    clear scoreSUM
    scoreSUM=[];
    for img=1:length(yy)
        scoreSUM(img,:)=sum([svm_scores(img,:); svm_scores(find(qualeOR==img),:)]);
    end
    [a,b]=max(scoreSUM');
    Perf(fold,2)=sum(b==yy)/400
    
    scoreSpiral{fold}=svm_scores;
    %('D:\c\Lavoro\Implementazioni\MusicGenre\Spiral\SpiralPat_ESC_TSM_score.mat','scoreSpiral');
    save('D:\c\Lavoro\Implementazioni\MusicGenre\Spiral\SpiralPat_ESC_TSM_reduced.mat','scoreSpiral','qualeOR');
 
end









