% I did a search for which feature vectors would give the best
% blind clustering, the answer turned out to be 12 of them:
%
% branchAssymetry dendriticDensity dendriticDiameter dendriticField
% densityOfBranchPoints fractalDimensionBoxCounting meanBranchAngle
% meanTerminalSegmentLength numBranchPoints numSegments somaArea
% totalDendriticLength
%
% I now want to know how many random features would be needed
% before you can get any partitioning of cells.
% 


  % 1. Generate a random feature matrix
  nCells = 94;
  nFeatures = 17;

  ID = [1*ones(19,1);
        2*ones(11,1);
        3*ones(26,1);
        4*ones(29,1);
        5*ones(9,1)];

  k = 5; % 5 classes

  reps = 1;

  ID = ID(randperm(numel(ID)));

  featureMat = rand(nCells,nFeatures);

  % Use r to get access to a function
  r = RGCclass(0);
  featureIdx = r.getSubsetOfFeatures(17);

  score = NaN*zeros(numel(featureIdx),1);
  
  parfor j = 1:4
    % I could have done one parfor loop without the inner loop, but
    % then I would not know the progress... need scoreTMP because
    % in the inner loop matlab got confused by score(i)
    scoreTMP{j} = NaN*zeros(numel(featureIdx),1);
    
    ctr(j) = 0;
    for i = j:4:numel(featureIdx)
      clusterID = kmeans(featureMat(:,featureIdx{i}), k,'replicates',reps);
      scoreTMP{j}(i) = r.blindScore(clusterID,ID);

      ctr(j) = ctr(j) + 1;
      if(mod(ctr(j),100) == 0)
        fprintf('%d/%d\n',i,numel(featureIdx))
      end
    end
  end
  
  % Combine the workers outputs
  for i = 1:4
    idx = find(~isnan(scoreTMP{i}));
    assert(all(isnan(score(idx))))
    score(idx) = scoreTMP{i}(idx);
  end
  
  [maxVal,maxIdx] = max(score);
  
  fprintf('Max score: %d, %d features\n', ...
          maxVal, numel(featureIdx{maxIdx}))

  clusterID = kmeans(featureMat(:,featureIdx{maxIdx}), k,'replicates',100);
  confMat = confusionmat(ID,clusterID)