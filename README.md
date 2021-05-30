# Environmental Sound Classification

Il presente codice permette la classificazione di suoni ambientali tramite machine learning addestrato sulla repository di file audio ESC-50. Ulteriormente, è possibile testare le performance dei classificatori ottenuti tramite il partizionamento della repository ESC-50, oppure utilizzando un set di test.

# Feature Extraction
Dati file audio di durata paragonabile ai 5s, l'estrazione delle feature per i pattern avviene attraverso il file **FeatureExtraction.m**, utilizzando un algoritmo iterativo basato su di una vettorizzazione a spirale in senso orario discendente e un pooling 2D-M4 con 16 momenti statistici.
# Feature Selection
I pattern ottenuti hanno dimensione 15360. La dimensionalità viene ridotta tramite un algoritmo NCA implementato internamente agli script di addestramento dei classificatori (**Train_Test_NN.m**,**Train_Test_SVM.m**).
## tSNE
Al fine di selezionare le feature migliori per la visualizzazione 3D dei pattern, utilizzare il file **tSNE.m**.

# Classificatori

I classificatori utilizzabili sono SVM e NN. 
## SVM
Facendo una run di **Train_Test_SVM.m** è possibile allenare e testare il classificatore SVM tramite un partizionamento 80-20 della repository ESC-50. Lo script ricorre alla funzione di addestramento descritta in **funzioni/trainClassifierSVM.m**.
## NN
Facendo una run di **Train_Test_NN.m** è possibile allenare e testare il classificatore NN tramite un partizionamento 80-20 della repository ESC-50.

# Test
I test possono essere eseguiti contestualmente all'allenamento dei classificatori, oppure utilizzando **Test_Set_Esteso.m**, dichiarando il classificatore da usare (purché salvato) e le feature da impiegare. Tale script utilizzerà un micro-set di 23 samples (**EXT/**).
Altrimenti è possibile utilizzare **Test_Record.m** per registrare e classificare i suoni in tempo reale.
# Augmentation
È possibile estendere il data-set ESC-50 tramite lo script **augmentation.m**. I nuovi file derivando da trasformazioni lineari dei suoni grazie alla funzione `augment()` di MatLab.

# File structure
Di seguito la struttura dei file. La cartella `root` è **Scripts**, ma richiede la presenza del data-set ESC-50 e EXT rispettivamente per l'addestramento e il testing esteso. Tali folder devono essere poste al medesimo livello della cartella **Scripts**

├── ESC-50
│   ├── ...
├── EXT
│   ├── ...
├── **Scripts**
│   ├── FeatureExtraction.m
│   ├── Test_Record.m
│   ├── Test_Set_Esteso.m
│   ├── Train_Test_NN.m
│   ├── Train_Test_SVM.m
│   ├── classifier
│   │   ├── NN.mat
│   │   └── SVM.mat
│   ├── data-set
│   │   └── SouthSpiralPat_ESC_data.mat
│   ├── feature-selection
│   │   ├── NCA-NN.mat
│   │   └── NCA-SVM.mat
│   ├── funzioni
│   │   ├── SouthSpiralPat.m
│   │   ├── convertToDecimalValue.m
│   │   ├── createVectorDifference.m
│   │   ├── enviromentalSoundClassification.m
│   │   ├── extractBinaryFeatures.m
│   │   ├── featuresConcatenation.m
│   │   ├── matrixTrasformation.m
│   │   ├── pooling2DM4.m
│   │   ├── sortRank.m
│   │   └── trainClassifierSVM.m
│   ├── info-classes
│   │   └── nomi-classi.mat
│   ├── augmentation.m
└───└── tNSE.m



## Performance

Di seguito le performance ottenute dai due classificatori in relazione ai differenti training e test set.

|        Classificatore        |Training Set     |Test Set| Performance |
|----------------|-------------------------------|-----------------------------|---|
|SVM|80% di ESC-50          |20% di ESC-50          |**58.5%**|
|SVM|100% di ESC-50           |EXT      |52.75%|
|NN|80% di ESC-50|20% di ESC-50| 57.75%|
|NN|100% di ESC-50|EXT| **69.57%**|

