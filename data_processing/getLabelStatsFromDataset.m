function labelStats = getLabelStatsFromDataset(data, correspondence)
  % Store label and occurrences in a cell array
  labelStats = cell(numel(correspondence.keys), 1);

  keys = correspondence.keys;
  values = correspondence.values;

  for i = 1:numel(keys)
    labelStats{i} = {keys{i}, sum(data.('Label') == double(values{i}))};
  end

  benignCount = sum(ismember(data.Label, [correspondence('Non-Tor'), correspondence('NonVPN')]));
  darknetCount = sum(ismember(data.Label, [correspondence('Tor'), correspondence('VPN')]));

  % Display the unique values and their occurrences
  for i = 1:numel(labelStats)
    fprintf('%s: %s\n', labelStats{i}{1}, formatNumber(labelStats{i}{2}));
  end
  fprintf('[Benign (NonVPN + Non-Tor): %s | Darknet (VPN + Tor): %s]\n', formatNumber(benignCount), formatNumber(darknetCount));
end