% This script uses the data from Feldmeyer taken from Neuromorpho.org to see how our method
% performs on that data set.

close all, clear all

loadCache = false;

if(loadCache)
  r = RGCclass(0);
  r.lazyLoad('Feldmeyer');
else

  r = RGCclass('DATA/Feldmeyer');
  
  r.dataSetName = 'Feldmeyer';
  
  for i = 1:numel(r.RGC)
    r.RGC(i).nameList = {'Horizontal', ...
                        'Inverted','Multipolar', ...
                        'Pyramidal', 'Tangenital', ...
                        }; %    'Interneuron' --- excluded, only 3 cells
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
  r.lazySave('Feldmeyer')
end
