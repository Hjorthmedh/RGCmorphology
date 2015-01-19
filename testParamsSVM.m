close all, clear all

r = RGCclass(0);
r.lazyLoad();

r.classifierMethod = 'SVM';

goodFiveFeatSet = { 'densityOfBranchPoints', ...
                    'dendriticField', ...
                    'somaArea', ...
                    'fractalDimensionBoxCounting', ...
                    'meanTerminalSegmentLength' };

r.setFeatureMat(goodFiveFeatSet);

nRep = 10;
dataIdx = ceil(nRep*rand(numel(r.RGC),nRep));

[corrFrac,corrFracSD] = r.benchmark(nRep,dataIdx);

s = SVM();

fprintf('C = %.2f, Correct: %.2f +/- %.2f %%\n', ...
        s.C, corrFrac*100, 100*corrFracSD/sqrt(nRep))