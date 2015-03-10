% This script uses the data from Gulyas taken from Neuromorpho.org to see how our method
% performs on that data set.

close all, clear all

loadCache = true;

if(loadCache)
  r = RGCclass(0);
  r.lazyLoad('Gulyas');
else

  r = RGCclass('/Users/hjorth/DATA/NeuroMorpho.org/gulyas/CNG version');
  
  r.dataSetName = 'Gulyas';
  
  for i = 1:numel(r.RGC)
    r.RGC(i).nameList = {'cb','cr','cck','pv','pc'};
    [r.RGC(i).typeID,r.RGC(i).typeName] = r.RGC(i).RGCtype();
  end

  % Restrict feature set used
  r.featuresUsed = {'branchAssymetry', ...
                    'dendriticDensity', ...
                    'dendriticDiameter', ...
                    'dendriticField', ...
                    'densityOfBranchPoints', ...
                    'fractalDimensionBoxCounting', ...
                    'meanBranchAngle', ...
                    'meanSegmentLength', ...
                    'meanSegmentTortuosity', ...
                    'meanTerminalSegmentLength', ...
                    'numBranchPoints', ...
                    'totalDendriticLength'};
  
  r.allFeatureNames = r.featuresUsed;
  
  r.updateTables(r.featuresUsed);
  r.lazySave('Gulyas')
end
