d=dir('../ESC-50');% directory dove avete salvato il dataset
d(ismember( {d.name}, {'.', '..'})) = []; 

% per ogni classe, augmentation
for classe = 1:50
    % estrazione label da nome file
    nm = strcat(d(classe).name);
    folder = fullfile("../ESC-50/" + nm);
    
    % dataset dei samples della folder
    ADS = audioDatastore(folder);
    numFilesInDataset = numel(ADS.Files);
    
    % impostazione dell'augmenter
    % 10 file aumentati
    % 80% di probabilità di stretching temporale
    % velocizzazione nel range [0.9,1.4]
    % 10% di probabilità di cambiamento di pitch
    % 80% di probabilità di cambiamento volume (gain +-5)
    % 5% di probabilità di aggiunta di rumore additivo
    % 80% di probabilità di traslaziione temporale pari a +-1%
    
    aug = audioDataAugmenter(...
            "NumAugmentations",10, ...
            ...
            "TimeStretchProbability",0.8, ...
            "SpeedupFactorRange", [0.9,1.4], ...
            ...
            "PitchShiftProbability",0.1, ...
            ...
            "VolumeControlProbability",0.8, ...
            "VolumeGainRange",[-5,5], ...
            ...
            "AddNoiseProbability",0.05, ...
            ...
            "TimeShiftProbability",0.8, ...
            "TimeShiftRange", [-1e-2,1e-2]);

    % augmentation
    while hasdata(ADS)
        [audioIn,info] = read(ADS);

        data = augment(aug,audioIn,info.SampleRate);

        [~,fn] = fileparts(info.FileName);
        for i = 1:size(data,1)
            augmentedAudio = data.Audio{i};

            % se l'augmentation crea un segnale che ha valori fuori dal range [-1,1]
            % si normalizza
            if max(abs(augmentedAudio),[],'all')>1
                augmentedAudio = augmentedAudio/max(abs(augmentedAudio),[],'all');
            end
            
            name = strsplit(nm," - ");
            name = name{2};
            
            % salvataggio
            
            filename = sprintf("..\\AUG\\%s_aug%d.wav",name,i);
            audiowrite(filename,augmentedAudio,info.SampleRate)
        end
    end
end