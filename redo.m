clear all, close all
r = RGCclass(0); % 0 means load nothing
disp('Using all features')
r.featuresUsed = setdiff(r.allFeatureNames, ...
												 {'meanAxonThickness', ...
													'dendriticVAChT'});

r.lazyLoad(); % Load previously cached data
% r.featureSelection();

rGUI = RGCgui(r);
setupGUI(rGUI);
