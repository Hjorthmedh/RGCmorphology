% Confusion matrix table for blind clustering in article

close all, clear all


r = RGCclass(0);
r.lazyLoad();

useFeatures = { 'numBranchPoints', ...
                'meanSegmentLength', ...
                'dendriticField', ...
                'totalDendriticLength', ...
                'somaArea', ...
                'biStratificationDistance', ...
                'meanBranchAngle', ...
                'meanSegmentTortuosity', ...
                'stratificationDepth' };


useFeaturesAlt = { 'branchAssymetry', ...
                   'dendriticDensity', ...
                   'dendriticDiameter', ...
                   'dendriticField', ...
                   'densityOfBranchPoints', ...
                   'fractalDimensionBoxCounting', ...
                   'meanBranchAngle', ...
                   'meanTerminalSegmentLength', ...
                   'numBranchPoints', ...
                   'numSegments', ...
                   'somaArea', ... 
                   'totalDendriticLength' };


r.setFeatureMat(useFeatures);
% !!! WRONG this one trains a classifier data ....
assert(0)
CML = r.confusionMatrixLeaveOneOut();
makeLatexTable(r.RGCuniqueNames, r.RGCuniqueNames, CML, '%d')

for i = 1:numel(r.featuresUsed)
  fprintf('%s, ', r.featureNameDisplay(r.featuresUsed{i}))
end
disp(' ')

r.setFeatureMat(useFeaturesAlt);
% !!! WRONG, see above. Need to do kmeans clustering... see blindClusteringBatch.m
CML2 = r.confusionMatrixLeaveOneOut();
makeLatexTable(r.RGCuniqueNames, r.RGCuniqueNames, CML2, '%d')

for i = 1:numel(r.featuresUsed)
  fprintf('%s, ', r.featureNameDisplay(r.featuresUsed{i}))
end
disp(' ')
