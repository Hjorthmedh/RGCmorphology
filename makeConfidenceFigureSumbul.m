r = RGCclass(0); r.lazyLoad('knownSumbul');

useFeatures = { 'biStratificationDistance', ...
                'densityOfBranchPoints ' ...
                'stratificationDepth', ...
                'totalDendriticLength' };

r.setFeatureMat(useFeatures)

r.predictionPosteriorProbabilitiesLeaveOneOut();
