clear all, close all

r = RGCclass(0);
r.lazyLoad();

r.allFeatureNames = setdiff(r.allFeatureNames, ...
														{'meanAxonThickness', ...
														 'stratificationDepthScaled', ...
														 'dendriticVAChT'});  

r.setFeatureMat(r.allFeatureNames);

r.plotFeatureMatCorrelation()

