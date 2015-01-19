% This code plots all the features to see if the new and old
% datasets are simlar or different

close all, clear all

r = RGCclass(0);
r.lazyLoad('Sumbul');

r.setFeatureMat(r.allFeatureNames);
r.plotFeatures();

for i = 1:numel(r.allFeatureNames)
  r.plotFeatures(r.allFeatureNames{i},false);
end

