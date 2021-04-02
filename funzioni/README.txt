Enviromental Sound Classification

1. mainSoundFeaturesGenerator
	This script contains the creation of the Struct of the sound file and the creation of the features matrix


1.1 datasetStruct = createDataStruct(pathToData) 	INPUT : pathToData = ...\ESC_50\meta\esc50.csv
	This function create a Dataset Struct to easly manipolate the data.
	*Attenzione* Riga 50 : path = ...\ESC_50\audio

1.2 featuresVectorConc = enviromentalSoundClassification(soundSignal)
	This function extracts the features from enviromental sound signal


1.2.1 featureVector = SpiralPat(rawEnviromentntalSound)
	This function generates the vector containing the features according to the Spiral pattern


1.2.1.1 threshold = calculateThreshold(soundSignal)
	This function calculates threshold value of the ternary function by using a standard deviation based calculation method


1.2.1.2 matrixTrasformed = matrixTrasformation(vector)
	This function converts the vector [1x25 double] to a matrix [5x5 double]


1.2.1.3 vectorDiff = createVectorDifference(matrixTrasformed)
	This function creates a vector [1x9 int] that represents the calculated differences according to the Spiral pattern


1.2.1.4 [bitSignum,bitLower,bitUpper] = extractBinaryFeatures(vectorDiff,threshold)
	This function extracts binary features by using signum and ternary functions


1.2.1.5 [valueSignum,valueLower,valueUpper] = convertToDecimalValue(bitSignum,bitLower,bitUpper)
	This function converts the extracted bits into decimal value


1.2.2 outputSignal = pooling2DM4(soundSignal)
	This function uses a multi-statistical moments based pooling method called as 2D-M4 pooling method. 16 statistical moments are used to reduce size of the input


1.2.3 featuresMultiLevel = featuresConcatenation(featuresVector)
	This function concatenates the features vectors of the multiLevel into one vector


2. accuracy = trainModel_FeatExtraction(numberOfFeaturesSelected,mod)           
	This function trains and tests a model, based on the method choosen + confusionMatrix + saving Net + accuracy
mod == ‘RESCALE’ or ‘NORESCALE’


2.1 featuresRanked = sortRank(features,rankList, numberFeatures)
	This function selects the number of features shown in Input.
	The indexes of the features are taken from the rankList, obtained as Output of the function fscmrmr.
	rankList = fscmrmr(features [2000x15360]) 


******* Per non dover generare la features Matrix ogni volta, nella funzione trainModel_FeatExctraction carico le features+rankList
	Nella cartella DropBox sono presenti questi due file, caso RESCALE e NORESCALE. 2Gb totali.
	Se non sono necessari possono essere eliminati, li ho salvati in Locale.	