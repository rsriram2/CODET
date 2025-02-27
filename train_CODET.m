disp('test')
mainFolder = '/Volumes/SRI/JHU COVID Research/Slices';
sections = {'B-Line', 'Control'};
imds = imageDatastore(fullfile(mainFolder, sections), 'LabelSource', 'foldernames', 'FileExtensions', '.mat','ReadFcn',@matRead);

secondaryFolder2 = fullfile(mainFolder, 'Test Set 3');
sections = {'Covid', 'Normal'};
valImds = imageDatastore(fullfile(secondaryFolder2, sections), 'LabelSource', 'foldernames', 'FileExtensions', '.mat','ReadFcn',@matRead);

predImds = shuffle(valImds);

[trainingSet, testSet] = splitEachLabel(imds, 0.7, 'randomize');
testLabels = testSet.Labels;

%testImds = imageDatastore(cat(1,valImds.Files,testSet.Files),'LabelSource', 'foldernames', 'FileExtensions', '.mat','ReadFcn',@matRead);


net = alexnet;
layers = net.Layers;
layers = layers(1: end - 3);

sizeImage = net.Layers(1).InputSize;

aTrainingSet = augmentedImageDatastore(sizeImage, trainingSet, 'ColorPreprocessing', 'gray2rgb');
aTestSet = augmentedImageDatastore(sizeImage, testSet, 'ColorPreprocessing', 'gray2rgb');
aVal = augmentedImageDatastore(sizeImage, predImds, 'ColorPreprocessing', 'gray2rgb');

layers(end + 1) = fullyConnectedLayer(64, 'Name', 'special_2');
layers(end + 1) = reluLayer;
layers(end + 1) = fullyConnectedLayer(2, 'Name', 'fc8_2');
layers(end + 1) = softmaxLayer;
layers(end + 1) = classificationLayer();

layers(end - 2).WeightLearnRateFactor = 20;
layers(end - 2).WeightL2Factor = 1;
layers(end - 2).BiasLearnRateFactor = 20;
layers(end - 2).BiasL2Factor = 0;

opts = trainingOptions('sgdm', 'LearnRateSchedule', 'none', 'InitialLearnRate', .0001, 'MaxEpochs', 10, 'MiniBatchSize', 16, 'Plots', 'training-progress');

model = trainNetwork(aTrainingSet, layers, opts);

I = imread("pic1.jpeg");
I = imresize(I,sizeImage(1:2));
[YPred, scores] = classify(model, I);

valLabels = predImds.Labels;
matrix = confusionmat(valLabels, prediction)
matrix = bsxfun (@rdivide, matrix, sum(matrix,2));
mean(diag(matrix))
