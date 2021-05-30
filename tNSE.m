clear all
warning off

% caricamento dei patterns/labels

load('data-set/SouthSpiralPat_ESC_data.mat','DATA');

DIV=DATA{3};

labels=DATA{2};

labels = labels.';

Patterns=DATA{1};

rng("default")

feature = Patterns;

% tSNE per estrazione delle feature graficamente più significative

Y = tsne(feature,'Standardize',true,'NumDimensions',3);

% visualizzazione 3D

scatter3(Y(:,1),Y(:,2),Y(:,3),30,labels,'o','filled')



