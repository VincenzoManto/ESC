clear all
warning off


%% Set the hyperparameters for rescaling the spectrograms
% the values of the spectrogram are linarly rescaled to 0-255 by mapping
% the pixels with intensity M and m respectively to 255 and 0.
M = 20;
m = -400;
% the audio signal is cut or padded to be audioLength seconds long.
audioLength = 5;

d=dir('D:\c\Lavoro\DATA\DATA\MusicGenre\ESC-50\v2-wav');%directory dove hai salvato il dataset
cd('D:\c\Lavoro\DATA\DATA\MusicGenre\ESC-50\v2-wav')

%leggi tutti i file audio
tmp=1;
pattern=dir('*.wav');
for num=1:length(pattern)
    [Y{1}, FS{1}]=audioread(pattern(num).name);
    data{tmp}=Y{1};fs{tmp}=FS{1};%segnale e frequenza
    spe = enviromentalSoundClassification(Y{1});%creo feature vector
    trova=find(pattern(num).name=='-');%trovo label partendo dal nome
    fold(tmp)=str2num(pattern(num).name(1:trova(1)-1));%trovo label partendo dal nome
    label(tmp)=str2num(pattern(num).name(trova(3)+1:end-4))+1;%assegno label
    Img(tmp,:)=spe;%salvo features
    tmp=tmp+1;
end
cd ..


DATA{1}=Img;
DATA{2}=label+1;

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

%salva i nuovi dati con istruzione save
save('D:\c\Lavoro\Implementazioni\MusicGenre\Spiral\SpiralPat_ESC_data.mat','-v7.3','DATA');




