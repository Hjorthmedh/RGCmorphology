% This file writes N list of features that the workers can then process

close all, clear all
tic

rng('shuffle')

r = RGCclass(0);
r.lazyLoad();

nWorkers = 4;
nFolds = 5;
nRep = 200;

featureIdx = r.getSubsetOfFeatures();

for i = 1:nWorkers
  workList{i} = {};
end

for i = 1:numel(featureIdx)
  workerID = mod(i-1,nWorkers) + 1;
  workList{workerID}{end+1} = featureIdx{i};
end

% Create the folds, use multiple times
dataIdx = ceil(nFolds * rand(numel(r.RGC),nRep));

parfor i = 1:nWorkers
    
  rLoop = RGCclass(0);
  rLoop.lazyLoad();

  correctFrac{i}     = zeros(numel(workList{i}),nRep);
  correctFracMean{i} = zeros(numel(workList{i}),1);
  correctFracSD{i}   = zeros(numel(workList{i}),1);
  
  for j = 1:numel(workList{i});

    if(mod(j,100) == 0)
      fprintf('Worker %d: %d/%d\n', i, j, numel(workList{i}))
    end
    
    featureList = rLoop.allFeatureNames(workList{i}{j});
    rLoop.setFeatureMat(featureList);
  
    [correctFracMean{i}(j),correctFracSD{i}(j), correctFrac{i}(j,:), ...
     classifiedAsID{i}(:,:,j),corrFlag{i}(:,:,j)] = ...
        rLoop.benchmark(nRep,dataIdx);
    
  end
  
end

corrFrac = [];
corrFracMean = [];
corrFracSD = [];
predictedID = [];

featureListIdx = {};

for i = 1:nWorkers
  corrFrac = [corrFrac; correctFrac{i}];
  corrFracMean = [corrFracMean; correctFracMean{i}];
  corrFracSD = [corrFracSD; correctFracSD{i}];
  predictedID = cat(3,predictedID,classifiedAsID{i});
  
  for j = 1:numel(workList{i})
    featureListIdx{end+1} = workList{i}{j};
  end
  
end


allFeatureNames = r.allFeatureNames;
classifierMethod = r.classifierMethod;
featureNameDisplay = r.featureNameDisplay;
RGCtypeID = r.RGCtypeID;
RGCtypeName = r.RGCtypeName;

fName = sprintf('RESULTS/ExhaustiveFeatureSearch-NaiveBayes-%d.mat',nRep);

fprintf('Saving to %s\n', fName)
save(fName, ...
     'corrFrac','corrFracMean','corrFracSD', ...
     'featureNameDisplay', ...
     'RGCtypeID', 'RGCtypeName', ...
     'allFeatureNames','classifierMethod', ...
     'featureListIdx', 'predictedID', ...
     'nFolds','nRep','dataIdx')

toc