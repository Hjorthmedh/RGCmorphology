clear all, close all

d = dir('FIGS/*fig');

for i = 1:numel(d)
  fName = sprintf('FIGS/%s', d(i).name);
  f = openfig(fName);
end