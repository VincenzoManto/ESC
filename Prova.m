predicteds = {};
real = {'Keyboard typing','Coughing','Snoring','Sneezing','Door knock','Dog','Door'};
for i = 1:length(real)
recObj = audiorecorder(48000,16,1);

disp('Inizio')
recordblocking(recObj, 5);
disp('Stop');
y = getaudiodata(recObj);

spe = enviromentalSoundClassification(y);%creo feature vector mediante Spiral
%play(recObj);
load("release/lastClassifier");
%plot(y);
load("release/selidx");
spe = spe(:,selidx);

d=dir('../ESC-50');%directory dove avete salvato il dataset
d(ismember( {d.name}, {'.', '..'})) = [];  %remove . and ..

nm = {};
for classe=1:50
    split = strsplit(d(classe).name," - ");
    nm = [nm, split(2)];
end

predicted = predict(classifier.Classifier,spe);
predicteds = [predicteds, nm(predicted)];
disp("Secondo me è un " + nm(predicted))
end
confusionchart(real,predicteds);
