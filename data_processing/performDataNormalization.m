function normalizedFeatures = performDataNormalization(features)
  % Normalize the features
  normalizedFeatures = normalize(features);

  % Handle columns with zero standard deviation to prevent having NaN values
  % after normalization
  zeroStdDevColumns = std(features) == 0;
  normalizedFeatures(:, zeroStdDevColumns) = 0;  % Set values to 0
end