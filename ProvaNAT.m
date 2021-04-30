predicteds = {};


load("release/selidxSVM");
load("C:\Users\vincm\Desktop\Vincenzo\Universita\3.2\AI\Progetto\Spiral\release\svmClassifier");

d=dir('../ESC-50');%directory dove avete salvato il dataset
d(ismember( {d.name}, {'.', '..'})) = [];  %remove . and ..

nm = {};
for classe=1:50
    split = strsplit(d(classe).name," - ");
    nm = [nm, split(2)];
end

real = {};
d=dir('../AUG2');%directory dove avete salvato il dataset
d(ismember( {d.name}, {'.', '..'})) = [];  %remove . and ..
cd ../AUG2
pattern=dir('*.wav');

correct = 0;
total = 1;

fprintf("SVM-FP Classifier + 800-NCA\n______________________\n");
for num=1:length(pattern)
    [Y{1}, FS{1}]=audioread(pattern(num).name);
    name = pattern(num).name;
    spe = enviromentalSoundClassification(Y{1});%creo feature vector mediante Spiral

    spe = spe(:,selidx);
    
    name = strsplit(name,"_");
    name = name{1};
    predicted = predict(classifier.Classifier,spe);
    predicteds = [predicteds, nm(predicted)];
    real = [real, name];
    if (nm(predicted) + "") == name
        correct = correct + 1;
        percentage = round(correct / total * 100,2);
        fprintf(1,nm(predicted) + "\t\t" + name + "\t\t" + percentage + "%%\n");
    else 
        percentage = round(correct / total * 100,2);
        fprintf(2,nm(predicted) + "\t\t" + name + "\t\t" + percentage + "%%\n" );
    end
    total = total + 1;
end

confusionchart(real,predicteds);
accuracy = correct / length(pattern)
