% Main
tic
disp('Creating Structures: ...');
soundStruct = createDataStruct(...
                    'C:\Users\matpa\Documents\TESI\ESC_50\meta\esc50.csv');
toc

tic
disp('Creating Features Vectors: ...')
nDati = length(soundStruct);
features = NaN(2000,15360);

for i = 1:nDati

   features(i,:) = enviromentalSoundClassification(soundStruct(i).data);
   
   Y(i) = soundStruct(i).target;
   disp(i)
    
end

Y = Y';
toc
