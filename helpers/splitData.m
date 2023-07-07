function [trainData, valData, testData] = splitData(data, trainRatio, valRatio, testRatio)
  % Calculate the number of rows for each data split
  numRows = size(data, 1);
  trainRows = round(numRows * trainRatio);
  valRows = round(numRows * valRatio);
  testRows = numRows - trainRows - valRows;

  correspondence = containers.Map({'Tor', 'VPN', 'Non-Tor', 'NonVPN'}, {1, 2, 3, 4});

  % Tor
  idx = data.Label == correspondence('Tor');
  dataTor = data(idx, :);
  trainRowsTor = round(size(dataTor, 1) * trainRatio);
  valRowsTor = round(size(dataTor, 1) * valRatio);
  testRowsTor = size(dataTor, 1) - trainRowsTor - valRowsTor;

  % VPN
  idx = data.Label == correspondence('VPN');
  dataVPN = data(idx, :);
  trainRowsVPN = round(size(dataVPN, 1) * trainRatio);
  valRowsVPN = round(size(dataVPN, 1) * valRatio);
  testRowsVPN = size(dataVPN, 1) - valRowsVPN - valRowsVPN;

  % Non-Tor
  idx = data.Label == correspondence('Non-Tor');
  dataNonTor = data(idx, :);
  trainRowsNonTor = round(size(dataNonTor, 1) * trainRatio);
  valRowsNonTor = round(size(dataNonTor, 1) * valRatio);
  testRowsNonTor = size(dataNonTor, 1) - trainRowsNonTor - valRowsNonTor;
  
  % NonVPN
  idx = data.Label == correspondence('NonVPN');
  dataNonVPN = data(idx, :);
  trainRowsNonVPN = round(size(dataNonVPN, 1) * trainRatio);
  valRowsNonVPN = round(size(dataNonVPN, 1) * valRatio);
  testRowsNonVPN = size(dataTor, 1) - trainRowsNonVPN - valRowsNonVPN;

  % Split the data into training, validation, and testing sets
  trainData = [dataTor(1:trainRowsTor, :) ...
                ;dataNonTor(1:trainRowsNonTor, :) ...
                ;dataVPN(1:trainRowsVPN, :) ...
                ;dataNonVPN(1:trainRowsNonVPN, :) ...
                ];

  valData = [dataTor(trainRowsTor + 1:trainRowsTor + valRowsTor, :) ...
              ;dataNonTor(trainRowsNonTor + 1:trainRowsNonTor + valRowsNonTor, :) ...
              ;dataVPN(trainRowsVPN + 1:trainRowsVPN + valRowsVPN, :) ...
              ;dataNonVPN(trainRowsNonVPN + 1: trainRowsNonVPN + valRowsNonVPN, :) ...
              ];

  testData = [dataTor(trainRowsTor + valRowsTor + 1:end, :) ...
                ;dataNonTor(trainRowsNonTor + valRowsNonTor + 1:end, :) ...
                ;dataVPN(trainRowsVPN + valRowsVPN + 1:end, :) ...
                ;dataNonVPN(trainRowsNonVPN + valRowsNonVPN + 1:end, :)];
end