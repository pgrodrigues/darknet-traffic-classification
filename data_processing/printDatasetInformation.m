function stats = printDatasetInformation(data, correspondence, datasetName)
  columnNames = data.Properties.VariableNames;

  fprintf('\n### %s dataset ###', datasetName);
  for i = 1:numel(columnNames)
    fprintf('#\n%d | Name: %s | Type: %s', i, columnNames{i}, class(data.(columnNames{i})(1)));
  end
  fprintf('\n\nNumber of columns: %d', width(columnNames));
  fprintf('\nNumber of records: %s\n\n', formatNumber(height(data)));
  stats = getLabelStatsFromDataset(data, correspondence);
  fprintf('########################\n');
end