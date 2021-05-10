load('release/SpiralPat_ESC50_data.mat','DATA');

label=DATA{2};

myLabels = label.';

Pattern=DATA{1};

rng("default")



foldData = Pattern;


c = cvpartition(label,"Holdout",0.20);
 
indiciTR = training(c);
indiciTE = test(c);

dataTR.feature = foldData(indiciTR,:);
dataTR.label = myLabels(indiciTR);

dataTE.feature = foldData(indiciTE,:);
dataTE.label = myLabels(indiciTE);
lambdavals = linspace(1,21,20)/ (10 * length(dataTR.label))

lossvals = zeros(length(lambdavals));

for i = 1:length(lambdavals)

    nca = fscnca(dataTR.feature,dataTR.label,'FitMethod','exact', ...
         'Solver','sgd','Lambda',0, ...
         'IterationLimit',30,'GradientTolerance',lambdavals(i), ...
         'Standardize',true);

    lossvals(i) = loss(nca,dataTE.feature,dataTE.label,'LossFunction','classiferror');
end
meanloss = mean(lossvals,2);
figure()
plot(lambdavals,meanloss,'ro-')
xlabel('Lambda')
ylabel('Loss (MSE)')
grid on