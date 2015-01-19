% Kong et al 2005 uses Dendritic Field, Dendritic Density and
% Stratification Depth. How well would a classifier do with that?
%

close all, clear all
r = RGCclass(0);
r.lazyLoad();

featSet = {'stratificationDepth','dendriticField','dendriticDensity'};

r.setFeatureMat(featSet)

[corrFrac,corrFracSD] = r.benchmark(1000);

fprintf('Correct: %.1f +/- %.1f\n', corrFrac*100,corrFracSD*100)
