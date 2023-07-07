close all
clear

% Read the CSV file into a table
path = '.\datasets\Darknet_preprocessed.csv';
data = readtable(path, 'PreserveVariableNames', true);

[trainData, valData, testData] = splitData(data, 0.6, 0.2, 0.2);

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

% Define the architecture of the shallow MLP neural network
hiddenUnits = [5 5];  % Number of hidden units
net = patternnet(hiddenUnits);
net.trainFcn = 'trainlm';  % Use Levenberg-Marquardt backpropagation algorithm
net.performFcn = 'mse';  % Use mean squared error as the performance metric

% Set up the training parameters
net.trainParam.showWindow = true;  % Show the training progress window
net.trainParam.max_fail = 10;  % Maximum validation failures
net.trainParam.epochs = 200;  % Maximum number of epochs
net.trainParam.goal = 0;  % Training goal (MSE of 0)
net.divideParam.trainRatio = 1;
net.divideParam.valRatio = 0;
net.divideParam.testRatio = 0;

% Train the neural network
net = train(net, trainFeatures', dummyvar(trainLabels)', 'useParallel', 'yes');

% Provide the network with the validation set
valPredMatrix = net(valFeatures');
[~, valPred] = max(valPredMatrix);  % Convert matrix to vector of indices
valAccuracy = calculateAccuracyFromPrediction(valPred', valLabels);

% Create the confusion matrix
figure;
ccv = confusionchart(valLabels, valPred');
ccv.title('Validation confusion Matrix');
ccv.RowSummary = 'row-normalized';
ccv.ColumnSummary = 'column-normalized';

% Provide the network with the testing set
testPredMatrix = net(testFeatures');
[~, testPred] = max(testPredMatrix);  % Convert matrix to vector of indices
testAccuracy = calculateAccuracyFromPrediction(testPred', testLabels);

% Create the confusion matrix
figure;
cct = confusionchart(testLabels, testPred');
cct.title('Test Confusion Matrix');
cct.RowSummary = 'row-normalized';
cct.ColumnSummary = 'column-normalized';