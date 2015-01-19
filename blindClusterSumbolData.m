% This code reads in the Sumbul dataset and our data, and then does
% a blind hierarchical clustering

clear all, close all

featureList = { 'dendriticDensity', ...
                'densityOfBranchPoints', ...
                'meanSegmentTortuosity', ...
                'numBranchPoints', ...
                'totalDendriticLength' };

r = RGCclass(0);
r.lazyLoad('Sumbul');

r.setFeatureMat(featureList);

Ydist = pdist(r.featureMat);
Zlink = linkage(Ydist);
dendrogram(Zlink,inf,'labels',r.RGCtypeName);
