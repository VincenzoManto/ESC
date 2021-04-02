clear all
warning off

d=dir('D:\c\Lavoro\DATA\DATA\MusicGenre\ESC-50');%directory dove hai salvato il dataset
cd('D:\c\Lavoro\DATA\DATA\MusicGenre\ESC-50')
addpath(genpath('D:\c\Lavoro\DATA\DATA\MusicGenre\'))
addpath(genpath('D:\c\Lavoro\Implementazioni\MusicGenre\'))

%% Set the hyperparameters for rescaling the spectrograms
% the values of the spectrogram are linarly rescaled to 0-255 by mapping
% the pixels with intensity M and m respectively to 255 and 0.
M = 20;
m = -400;
% the audio signal is cut or padded to be audioLength seconds long.
audioLength = 5;

tmp=1;
for classe=3:52
    cd(strcat(d(classe).name));
    pattern=dir('*.ogg');
    for num=1:length(pattern)
        [Y{1}, fs{tmp}]=audioread(pattern(num).name);
        FS{1}=fs{tmp};
        spect = enviromentalSoundClassification(Y{1});%creo feature vector
        audioD{tmp}=Y{1}(:,1);
        trova=find(pattern(num).name=='-');
        fold(tmp)=str2num(pattern(num).name(1:trova-1));
        label(tmp)=classe-2;
        Img(tmp,:)=single(spect);%salvo features
        
        %data augmentation
        NewSignal{tmp}=mainTSMtoolbox(Y{1},fs{tmp},0.5);
        NewSignal2{tmp}=mainTSMtoolbox(Y{1},fs{tmp},1.8);
        
        tmp=tmp+1;
    end
    cd ..
end


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
DATA{5}=2000;


%data augmentation
tmp=1;
clear Im newAudioData
%data augmentation
for imm=946:2000
    tmp=1;
    for i = 1:length(NewSignal{imm})
        %generate new data. We apply 5 different augmentations to every
        %sample
        newAudioData{1}=NewSignal{imm}{i};
        NewSignal{imm}{i}=[];
        FS{1}=fs{imm};
        spect = enviromentalSoundClassification(newAudioData{1});%creo feature vector
        ImNA{tmp}{imm}= single(spect);
        tmp=tmp+1;
    end
    
    tmp=1;
    for i = 1:length(NewSignal2{imm})
        %generate new data. We apply 5 different augmentations to every
        %sample
        newAudioData{1}=NewSignal2{imm}{i};
        NewSignal2{imm}{i}=[];
        spect = enviromentalSoundClassification(newAudioData{1});%creo feature vector
        ImNB{tmp}{imm}= single(spect);
        tmp=tmp+1;
    end
    
end

%per kfold cross validation
DATA{6}=ImNA;
DATA{7}=ImNB;

save('D:\c\Lavoro\Implementazioni\MusicGenre\Spiral\SpiralPat_ESC_TSM.mat','-v7.3','DATA');




