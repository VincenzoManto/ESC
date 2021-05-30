clear variables
warning off
addpath("funzioni");
% numero di classi
MAX = 50; 

% directory ESC dataset
d = dir('../ESC-50');
cd('../ESC-50')
d(ismember({d.name}, {'.', '..'})) = [];  

tmp = 1;

% per ogni classe
for class = 1:MAX
    nm = strcat(d(class).name);
    cd(strcat(d(class).name));
    pattern = dir('*.ogg');
    
    % per ogni pattern
    for num = 1:length(pattern)
        % lettura
        [Y{1}, ~] = audioread(pattern(num).name); 
        data{tmp} = Y{1};
        
        % estrazione label da filename
        trova = find(pattern(num).name=='-'); 
        fold(tmp) = str2num(pattern(num).name(1:trova-1)); 

        % estrazione feature
        spe = enviromentalSoundClassification(Y{1}); 

        % assegnamento labels
        label(tmp) = class;
        % salvataggio features
        features(tmp,:) = spe; 
        tmp = tmp+1;
        
        disp("Computed " + nm + ":" + pattern(num).name)
    end
    cd ..
end

% struttura data
DATA{1} = features;
DATA{2} = label;

% salvataggio
cd("../Scripts/data-set")
save('SouthSpiralPat_ESC_data.mat','-v7.3','DATA');
