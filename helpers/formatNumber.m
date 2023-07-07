function formattedNumber = formatNumber(number)
  dfs = java.text.DecimalFormatSymbols(java.util.Locale('pt-PT'));
  nf = java.text.DecimalFormat;
  nf.setDecimalFormatSymbols(dfs);

  formattedNumber = char(nf.format(number));
end