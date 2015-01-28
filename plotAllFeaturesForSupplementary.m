close all, clear all
r = RGCclass(0);
r.lazyLoad();

r.setFeatureMat(r.allFeatureNames);
r.plotFeatures();

for i = 1:numel(r.allFeatureNames)
  r.plotFeatures(r.allFeatureNames{i},false);
end

