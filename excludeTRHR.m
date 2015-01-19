% This script excludes the TRHR from the analysis

clear all, close all

r = RGCclass(0);
r.lazyLoad();

% We need to throw out the TRHR files

TRHRID = 5;
Cdh3ID = 2;

nBefore = numel(r.RGC);
removeIdx = find(r.RGCtypeID == TRHRID); 
% removeIdx = find(r.RGCtypeID == TRHRID | r.RGCtypeID == Cdh3ID);

assert(strcmpi(r.RGCtypeName{removeIdx(1)},'TRHR'))

r.RGC(removeIdx) = [];
r.updateTables(r.featuresUsed);

% Just make sure we cleared out something...
assert(nBefore > numel(r.RGC))

[fracCorr,fracCorrSD,~,~,~,mu,sigma] = r.benchmark(100);

fprintf('Correctly lassified %.1f +/- %.1f %%\n', fracCorr*100,fracCorrSD*100)

