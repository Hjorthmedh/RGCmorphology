close all, clear all

data = load('RESULTS/exhaustiveSearchResultsSummary.mat');

r = RGCclass(0);
r.lazyLoad();

featIdx = 5;
r.setFeatureMat(data.bestNfeatureSetsName{featIdx});
r.classifierMethod = 'SVM';

nRep = 5;
dataIdx = [];


[corrFraction,corrFractionSD,correctFraction, ...
  classifiedID,correctFlag, mu, sigma, dataIdx] = r.benchmark(nRep,[],true)

