% The idea here is to do blind clustering with different set of
% features, and see which of the feature sets gives a blind
% clustering that closest matches the genetic cluster

function bestFeaturesForBlindClustering(obj)

  nClusters = max(obj.RGCtypeID); % Run for 2,3,4,5, ... ?
  nReps = 10;
  nFeatMax = 17;
  
  fprintf('nClusters = %d\n', nClusters)
  
  % 1. Generate list of all feature sets we want to test

  featIdx = makeFeatureIndexList(numel(obj.allFeatureNames),nFeatMax);
  
  if(0)
    for i = 1:numel(featIdx),fprintf('%d ', featIdx{i}),fprintf('\n'),end
  end
  
  % 2. Use all features(!)
  % We might use leave-one-out at a later stage, to see if some
  % features are messing things up

  scoreList = zeros(numel(featIdx),1);
  silhouetteList = zeros(numel(featIdx),1);
  
  tic
  
  for idx = 1:numel(featIdx)
    
    if(mod(idx,100) == 0)
      fprintf('%d/%d\n', idx, numel(featIdx))
    end
    
    % Use the selected features
    featNames = obj.allFeatureNames(featIdx{idx});
    obj.updateTables(featNames);
    
    % Run blind clustering
    clusterID = obj.blindClustering(nClusters,nReps);
    
    % 3. Calculate a score for how well the blind clustering matches
    % the genetic labelling
    scoreList(idx) = obj.blindScore(clusterID,obj.RGCtypeID);
    silhouetteList(idx) = mean(silhouette(obj.featureMat,clusterID));
    
  end

  % Find best score
  [~,bestIdx] = sort(scoreList,'descend');
  
  fName = sprintf('SAVE/BestBlind/BestFeaturesForBlindClustering-%d-clusters-%d-features.txt', ...
                  nClusters, nFeatMax);
                  
  fid = fopen(fName,'w');
  
  for i = 1:numel(bestIdx)
    
    bIdx = bestIdx(i);
    
    printit(fid,sprintf('%d. Score: %d, silhouette: %.3f Features: (%d) ', ...
                        i, scoreList(bIdx), ...
                        silhouetteList(bIdx), ...
                        numel(featIdx{bIdx})))
    featNames = obj.allFeatureNames(featIdx{bIdx});
    
    for j = 1:numel(featNames)
      printit(fid,sprintf('%s ', featNames{j}))
    end
    
    printit(fid,'\n')
    
  end

  fclose(fid)

  try
    allFeatureNames = obj.allFeatureNames;
    numFeatures = zeros(numel(featIdx),1);
    for i = 1:numel(featIdx)
      numFeatures(i) = numel(featIdx{i});
    end
    
    fNameMat = strrep(fName,'.txt','.mat');

    save(fNameMat, ...
         'scoreList','silhouetteList', ...
         'featIdx','allFeatureNames', ...
         'nClusters','nFeatMax')
  catch e
    getReport(e)
    keyboard
  end
    
  
  [silVal,silIdx] = max(silhouetteList);
  
  p = plotyy(numFeatures,scoreList, ...
             numFeatures,silhouetteList);
  pc = get(p,'children');

  set(pc{1}, ...
      'linestyle','none', ...
      'marker', '.','markersize',25);
  set(pc{2}, ...
      'linestyle','none', ...
      'marker', 'o');

  
  
  toc
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function printit(fid,str)
    % Print both to screen and file
    fprintf(fid,str);
    fprintf(str)
  end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function fIdx = makeFeatureIndexList(maxIdx, nFeatures)

    fIdx = {};
    
    % Create the base case
    if(isempty(fIdx) & nFeatures > 0)
      
      for i = 1:maxIdx
        fIdx{i} = i;
      end
      
      nFeatures = nFeatures - 1;
      firstIdx = 1;
      
    end
    
    
    while(nFeatures > 0)
    
      lastIdx = numel(fIdx);
      
      for i = firstIdx:lastIdx

        idxStart = max(fIdx{i}) + 1;
        
        for j = idxStart:maxIdx
          
          fIdx{end+1} = [fIdx{i},j];
          
        end
        
      end
      
      nFeatures = nFeatures - 1;
      firstIdx = lastIdx + 1;
      
    end
    
  end
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
end