function [augmentedFeatures, augmentedLabels]= performDataAugmentation(features, labels)
  % Identify the minority class
  valueCounts = tabulate(labels);
  minCount = min(valueCounts(:, 2));
  minorityClass = valueCounts(valueCounts(:, 2) == minCount, 1);

  % Separate the minority class samples
  minorityIdx = labels == minorityClass;
  minorityX = features(minorityIdx, :);
  minorityY = labels(minorityIdx);
  
  % Apply SMOTE to the minority class
  k = 8;  % Number of nearest neighbors to consider
  
  % Call the smote function with additional arguments
  [Xn, Cn] = smote(minorityX, 8, k);
  
  % Combine the original and synthetic samples
  augmentedFeatures = [features; Xn];
  augmentedLabels = [labels; Cn];
end