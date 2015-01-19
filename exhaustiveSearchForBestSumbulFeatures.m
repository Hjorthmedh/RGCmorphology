% We want to find the feature set that gives a blind partitioning that is
% most similar to the genetic labeling

% We use all the data in the Sumbul set, but we only include the
% cells that are labelled in the verification.
% We do k-means, with a range of k to see which one gives best
% classification.

% Run loadSumbulFeatures.m to generate the save file that we use

% Analyse with analyseExhaustiveSearchForBestSumbulFeature

close all, clear all

nWorkers = 8;
nReps = 20; % Run with 1 rep just to check there are no bugs

saveFile = 'RESULTS/Sumbul-exhaustive-blind-clustering-search.mat';
workerFile = 'SumbulExhaustiveSearchStart';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataSet = 'Sumbul';
% dataSet = 'Iris';

switch(dataSet)
  
  case 'Sumbul'
    %
    % Load the Sumbul data

    r = RGCclass(0);
    r.lazyLoad('Sumbul'); % This includes both Rana and Sumbul

    r.allFeatureNames = { 'biStratificationDistance', ...
                          'branchAssymetry', ...
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
                          'stratificationDepth', ...
                          'totalDendriticLength' };

    % Restrict dataset to only Sumbul
    sumbulIdx = r.getRGCSubset('sumbul');
    r.RGC = r.RGC(sumbulIdx);
    clear sumbulIdx

    r.updateTables(r.allFeatureNames); % Also sets featureMatrix
    knownIdx = find(r.RGCtypeID > 0);

    r.lazySave('SumbulExhaustiveSearchStart');

  case 'Iris'
    
    r = RGCclass(0);
    r.dataSetName = 'Iris-verification';

    data = load('fisheriris');
  
    r.featureMat = data.meas;
  
    r.featuresUsed = {'Sepal Length','Sepal Width',...
                        'Petal Length','Petal Width'};

    r.allFeatureNames = r.featuresUsed;

    r.RGC = [];
    r.RGCtypeID = [];
    r.RGCtypeName = data.species;
  
    for i = 1:numel(data.species)

      switch(data.species{i})
        case 'setosa'
          r.RGC(i).RGCtypeID = 1;
          r.RGCtypeID(i,1) = 1;
        case 'versicolor'
          r.RGC(i).RGCtypeID = 2;        
          r.RGCtypeID(i,1) = 2;      
        case 'virginica'
          r.RGC(i).RGCtypeID = 3;    
          r.RGCtypeID(i,1) = 3;        
      end
      
    end
    
    knownIdx = 1:numel(r.RGC);
    
    saveFile = 'RESULTS/Iris-verification-exhaustive-blind-clustering-search.mat';
    workerFile = 'IrisVerificationExhaustiveSearchStart';
    r.lazySave(workerFile);

  otherwise
    fprintf('Unknown datast: %s\n', dataSet)
    return
    
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

featureIdx = r.getSubsetOfFeatures();
nClusterRange = numel(unique(r.RGCtypeID)):20;

for i = 1:nWorkers
  workList{i} = {};
end

for i = 1:numel(featureIdx)
  workerID = mod(i-1,nWorkers) + 1;
  workList{workerID}{end+1} = featureIdx{i};
end

clusterList = {};
clusterScore = {};

% Loop over the workers, reason for this overhead is that we do not
% want to make a new 

tic

parfor iWork = 1:numel(workList)
  
  rLoop = RGCclass(0);
  switch(dataSet)
    
    case 'Sumbul'
      rLoop.lazyLoad(workerFile);
      
    case 'Iris'
      rLoop.featureMat = r.featureMat;
      rLoop.RGC = r.RGC;
      rLoop.RGCtypeID = r.RGCtypeID;
      rLoop.RGCtypeName = r.RGCtypeName;
      
    otherwise
      
      fprintf('Unknown datast: %s\n', dataSet)
      keyboard
      
  end
      
      
  for iFeat = 1:numel(workList{iWork})
    
    if(mod(iFeat,10) == 0)
      fprintf('Worker: %d/%d, job: %d/%d\n', iWork, numel(workList), ...
              iFeat, numel(workList{iWork}))
    end
  
    featIdx = workList{iWork}{iFeat};

    switch(dataSet)
      case 'Sumbul'
        rLoop.setFeatureMat(rLoop.allFeatureNames(featIdx));
        
      case 'Iris'
        rLoop.featuresUsed = rLoop.allFeatureNames(featIdx);
        rLoop.featureMat = data.meas(:,featIdx);
      
      otherwise
       fprintf('Unknown dataset: %s\n', dataSet)
       keyboard
    end
        
    for iClust = 1:numel(nClusterRange)
      clusterID = kmeans(rLoop.featureMat, nClusterRange(iClust),'replicates',nReps);
      try
        clusterList{iWork}(iFeat,iClust,:) = clusterID;
      catch e
        getReport(e)
        keyboard
      end
        
      % Calculate the score for the partitioning, only use known
      % genetically labeled cells
      clusterScore{iWork}(iFeat,iClust) = ...
          rLoop.randIndex(clusterID(knownIdx), ...
                          rLoop.RGCtypeID(knownIdx));
    end
  
  end
  
end

toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Combine the data together into one big list

allFeatureList = {};
allClusterList = [];
allScoreList = [];

for iWork = 1:nWorkers
  
  allFeatureList = [allFeatureList, workList{iWork}];
  allClusterList = [allClusterList; clusterList{iWork}];
  allScoreList = [allScoreList; clusterScore{iWork}];
  
end

featureNames = r.allFeatureNames;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


save(saveFile, ...
     'allFeatureList', 'allClusterList', 'allScoreList','featureNames',...
     'knownIdx','nClusterRange','r');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




