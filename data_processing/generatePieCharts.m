function generatePieCharts(originalDataStats, preprocessedDataStats)
  labels = cellfun(@(x) x{1}, originalDataStats, 'UniformOutput', false);
  originalDataOccurrences = cellfun(@(x) x{2}, originalDataStats);
  preprocessedDataOccurrences = cellfun(@(x) x{2}, preprocessedDataStats);

  % Create pie chart for the original dataset
  figure;
  subplot(1, 2, 1);
  h1 = pie(originalDataOccurrences, labels);
  title(sprintf('Original dataset'));
  textObjects = findobj(h1, 'Type', 'text');
  combinedText = arrayfun(@(x) formatNumber(x), originalDataOccurrences, 'UniformOutput', false);
  [textObjects.String] = deal(combinedText{:});
  ax1 = gca;
  ax1.Title.Position(2) = ax1.Title.Position(2) + 0.25;
  totalOriginalOccurrences = sum(originalDataOccurrences);
  text(0, -1.2, sprintf('Samples: %s', formatNumber(totalOriginalOccurrences)), 'HorizontalAlignment', 'center');
  
  % Create pie chart for the preprocessed dataset
  subplot(1, 2, 2);
  h2 = pie(preprocessedDataOccurrences, labels);
  title(sprintf('Preprocessed dataset'));
  textObjects = findobj(h2, 'Type', 'text');
  combinedText = arrayfun(@(x) formatNumber(x), preprocessedDataOccurrences, 'UniformOutput', false);
  [textObjects.String] = deal(combinedText{:});
  ax2 = gca;
  ax2.Title.Position(2) = ax2.Title.Position(2) + 0.25;
  totalPreprocessedOccurrences = sum(preprocessedDataOccurrences);
  text(0, -1.2, sprintf('Samples: %s', formatNumber(totalPreprocessedOccurrences)), 'HorizontalAlignment', 'center');

  commonLegend = legend(labels, 'Location', 'south', 'Orientation', 'horizontal');
  set(commonLegend, 'Units', 'normalized', 'Position', [0.5, 0.05, 0.2, 0.05]);
end