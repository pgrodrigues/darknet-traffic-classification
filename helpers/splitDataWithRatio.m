function [trainData, valData, testData] = splitDataWithRatio(data, trainRatio, valRatio, testRatio)
  % Calculate the number of rows for each data split
  numRows = size(data, 1);
  trainRows = round(numRows * trainRatio);
  valRows = round(numRows * valRatio);
  testRows = numRows - trainRows - valRows;

  labels = {'Tor', 'VPN', 'Non-Tor', 'NonVPN'};
  correspondence = containers.Map(labels, {1, 2, 3, 4});
  datasets = cell(1, 4);

  % Split the data based on labels
  for i = 1:numel(labels)
    idx = data.Label == correspondence(labels{i});
    datasets{i} = data(idx, :);
  end

  % Initialize arrays to store the split data
  trainData = [];
  valData = [];
  testData = [];

  % Split the data into training, validation, and testing sets
  for i = 1:numel(datasets)
    currentData = datasets{i};
    currentSize = size(currentData, 1);

    % Calculate the number of rows for each subset
    trainRowsCurrent = round(currentSize * trainRatio);
    valRowsCurrent = round(currentSize * valRatio);
    testRowsCurrent = currentSize - trainRowsCurrent - valRowsCurrent;

    % Split the current subset into training, validation, and testing sets
    trainData = [trainData; currentData(1:trainRowsCurrent, :)];
    valData = [valData; currentData(trainRowsCurrent + 1:trainRowsCurrent + valRowsCurrent, :)];
    testData = [testData; currentData(trainRowsCurrent + valRowsCurrent + 1:end, :)];
  end
end