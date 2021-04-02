clear all
warning off


MAX = 50;



d=dir('../ESC-50');%directory dove avete salvato il dataset
cd('../ESC-50')
d(ismember( {d.name}, {'.', '..'})) = [];  %remove . and ..
%leggi tutti i file audio
tmp=1;
for classe=1:MAX
    nm = strcat(d(classe).name);
    cd(strcat(d(classe).name));
    pattern=dir('*.ogg');
    for num=1:length(pattern)
        [Y{1}, FS{1}]=audioread(pattern(num).name);


        disp("Computato " + nm + ":" + pattern(num).name)
        data{tmp}=Y{1};fs{tmp}=FS{1};%segnale e frequenza

        trova=find(pattern(num).name=='-');%trovo label partendo dal nome

        fold(tmp)=str2num(pattern(num).name(1:trova-1));%trovo label partendo dal nome 

        spe = enviromentalSoundClassification(Y{1});%creo feature vector mediante Spiral

        %(� l'indice della classe di sample (ex: DOG:3 � 3, DOG:4 � 4))

        label(tmp)=classe;%assegno label (� l'indice della classe/folder (ex: DOG � 1))
        Img(tmp,:)=spe;%salvo features
        tmp=tmp+1;

    end
    cd ..
end
%cd ..

DATA{1}=Img;
DATA{2}=label;

%per kfold cross validation
clear DIV
for i=1:5
    b=(fold == i);
    a=~b;
    a=find(a);
    b=find(b);
    DIV=[a b];
    DATA{3}(i,:)=DIV;
    DATA{4}=length(a);
end
DATA{5}=MAX*40;

%salva i nuovi dati con istruzione save
save('C:\Users\vincm\Desktop\Vincenzo\Universita\3.2\AI\Progetto\Spiral\release\SpiralPat_ESC50_data.mat','-v7.3','DATA');


disp("FINITO")

%{



cd 'C:\Users\vincm\Desktop\Vincenzo\Universita\3.2\AI\Progetto\Spiral\release\'
%carica features create nel file EstraggoESCspiral
load('SpiralPat_ESC_data.mat','DATA');

%estraggo info per lanciare il 5-fold
NF=size(DATA{3},1); %number of folders

DIV=DATA{3};

DIM1=DATA{4};

DIM2=DATA{5};

label=DATA{2};
Pattern=DATA{1};

%5-fold
for fold=1:NF
    close all force

    %divido training e test
    trainPattern=(DIV(fold,1:DIM1));
    testPattern=(DIV(fold,DIM1+1:DIM2));
    labelTrain=label(DIV(fold,1:DIM1));
    labelTest=label(DIV(fold,DIM1+1:DIM2));

    TR=Pattern(trainPattern,:);
    TE=Pattern(testPattern,:);

    %addestro e classifico con SVM
    learnersTemplate = templateSVM('Standardize',true);
    options = statset('UseParallel',true);
    Mdl = fitcecoc(TR,labelTrain,...
        'Learners',learnersTemplate,...
        'Options',options);
    [presunteLab,svm_scores]=predict(Mdl,TE, 'ObservationsIn', 'rows');
    scoreSpiral{fold}=svm_scores;%score ottenuti mediante SVM

    Perf_accuracy(fold)=sum(presunteLab==labelTest')/length(labelTest);%accuracy del fold
    save('SpiralPat_ESC_data_FINAL.mat','scoreSpiral');

end
fileID = fopen('text.txt', 'a');
disp(Perf_accuracy(1) * 100 + "% " + Perf_accuracy(2) * 100 + "% " + Perf_accuracy(3) * 100 + "% " + Perf_accuracy(4) * 100 + "% " + Perf_accuracy(5) * 100 + "%");
disp(mean(Perf_accuracy) * 100 + "%");
y = " %f %f %f %f %f \n";
fprintf(fileID, y, Perf_accuracy);
fclose(fileID);

%}

