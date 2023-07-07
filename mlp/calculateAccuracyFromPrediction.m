function accuracy = calculateAccuracyFromPrediction(prediction, realLabels)
  % Process the network prediction
  [~, predictedLabels] = max(prediction);
  predictedLabelsCategorical = categorical(predictedLabels);
  realLabelsCategorical = categorical(realLabels);

  % Calculate the prediction accuracy
  correctPredictions = sum(predictedLabelsCategorical == realLabelsCategorical);
  totalPredictions = numel(realLabelsCategorical);
  accuracy = correctPredictions / totalPredictions;
end