% Here we are using our data and the Sumbul dataset to try and
% identify the unknown classes they have

clear all, close all

  switch(featureSetToUse)
    case 'featuredFive'

      features = {'fractalDimensionBoxCounting', ...
                  'somaArea', ...
                  'meanTerminalSegmentLength', ...
                  'densityOfBranchPoints', ...
                  'dendriticField' };


      
r = RGCclass(0);
r.lazyLoad('Sumbul');
