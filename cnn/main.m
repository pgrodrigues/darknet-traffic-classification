close all
clear

% Read the CSV file into a table
path = '.\datasets\Darknet_preprocessed.csv';
data = readtable(path, 'PreserveVariableNames', true);

[trainData, valData, testData] = splitDataWithRatio(data, 0.6, 0.2, 0.2);

% Get the features but exclude the unnecessary columns
columnsToExclude = { 'Label' };
trainFeatures = table2array(trainData(:, ~ismember(data.Properties.VariableNames, columnsToExclude)));
trainLabels = table2array(trainData(:, 'Label'));
valFeatures = table2array(valData(:, ~ismember(data.Properties.VariableNames, columnsToExclude)));
valLabels = table2array(valData(:, 'Label'));
testFeatures = table2array(testData(:, ~ismember(data.Properties.VariableNames, columnsToExclude)));
testLabels = table2array(testData(:, 'Label'));

% Group Non-Tor (3) and NonVPN (4) together as benign traffic
trainLabels(trainLabels == 4) = 3;
valLabels(valLabels == 4) = 3;
testLabels(testLabels == 4) = 3;

% Convert labels to categorical
trainLabels = categorical(trainLabels);
valLabels = categorical(valLabels);
testLabels = categorical(testLabels);

% Reshape trainFeatures to a 4D array
trainFeatures = reshape(trainFeatures', [size(trainFeatures, 2), 1, 1, size(trainFeatures, 1)]);

% Reshape valFeatures to a 4D array
valFeatures = reshape(valFeatures', [size(valFeatures, 2), 1, 1, size(valFeatures, 1)]);

% Reshape testFeatures to a 4D array
testFeatures = reshape(testFeatures', [size(testFeatures, 2), 1, 1, size(testFeatures, 1)]);

% Define the layers
layers = [
  imageInputLayer([28 1 1]) % 28X1X1 refers to number of features per sample
  convolution2dLayer(3, 5, 'Padding', 'same')
  reluLayer
  fullyConnectedLayer(5) % 5 refers to number of neurons in next FC hidden layer
  fullyConnectedLayer(5) % 5 refers to number of neurons in next FC hidden layer
  fullyConnectedLayer(3) % 3 refers to number of neurons in next output layer (number of output classes)
  softmaxLayer
  classificationLayer
];

% Specify the training options
options = trainingOptions( ...
  'adam', ...
  'MaxEpochs', 8, ...
  'MiniBatchSize', 256, ...
  'ValidationData', { valFeatures, valLabels }, ...
  'ExecutionEnvironment', 'parallel', ...
  'Plots', 'training-progress');

% Train the network
trainedNet = trainNetwork(trainFeatures, trainLabels, layers, options);

% Evaluate the trained model
predictedLabels = classify(trainedNet, testFeatures);
accuracy = sum(predictedLabels == testLabels) / numel(testLabels);

% Create the confusion matrix
figure;
cct = confusionchart(testLabels, predictedLabels);
cct.title('Test Confusion Matrix');
cct.RowSummary = 'row-normalized';
cct.ColumnSummary = 'column-normalized';