% The purpose of this function is to investigate how the
% classification of the RGCs vary depending on which features are used.

function chooseFeatures(obj)

  tic
  
  %  obj.allFeatureNames = setdiff(obj.allFeatureNames, ...
  %                            {'meanAxonThickness', ...
  %                             'stratificationDepthScaled', ...
  %                             'dendriticVAChT'});  
  
  % obj.allFeatureNames = {'biStratificationDistance', ...
  %                     'dendriticDensity', ...
  %                     'dendriticField', ...
  %                     'meanSegmentTortuosity', ...
  %                     'somaArea', ...
  %                     'stratificationDepth', ...
  %                     'totalDendriticLength' };
  
  featureSetUsed = 'allNonVAChT';
  
  switch(featureSetUsed)
    
    case 'allNonVAChT'

    useFeatures = setdiff(obj.allFeatureNames, ...
                          {'meanAxonThickness', ...
                           'stratificationDepthScaled', ...
                           'dendriticVAChT'});       
      
    case 'nonCorr9'
  
      % These are the non-correlated features
      useFeatures = {'biStratificationDistance', ...
                     'dendriticDensity', ...
                     'dendriticField', ...
                     'fractalDimensionBoxCounting', ...
                     'meanBranchAngle', ...
                     'meanSegmentTortuosity', ...
                     'somaArea', ...
                     'stratificationDepth', ...
                     'totalDendriticLength' };
  
    otherwise
     
      fprinttf('Unknown featureSetUsed: %s\n', featureSetUsed)
      keyboard
      
  end
      
  obj.allFeatureNames = useFeatures;
  
  tmp = [];
 
  featureIdxList = {};
  featureList = {};

  featureIdx = 1:numel(obj.allFeatureNames);
  
  nFeatures = numel(obj.allFeatureNames);

  nFolds = 5;
  nBootstrap = 200 % 200; %10; % How many times to resample data
                    %200 takes about an hour
  
  % featureIdxList = allFourSets();
  % featureIdxList = allThreeSets();  
  featureIdxList = obj.getSubsetOfFeatures(); % Fully exhaustive search
  
  featureList = convertToNames(featureIdxList);

  classifiedAsID = zeros(numel(obj.RGC),nBootstrap,numel(featureList));
  corrFlags = NaN*zeros(size(classifiedAsID));
  
  [fileNames,fileDirs] = getFileNames();

  
  dataIdx = zeros(numel(obj.RGC),nBootstrap);
  
  % Save the indexes used to create the folds
  dataIdx = ceil(nFolds * rand(numel(obj.RGC),nBootstrap));

  % Check how good each set of features is for classification
  correctFrac = zeros(numel(featureList),nBootstrap);
  correctFracMean = zeros(numel(featureList),1);
  correctFracSD = zeros(numel(featureList),1);
  
  % Do NOT parallellise this function, it changes internal states
  % of the object
  for i = 1:numel(featureList)
    
    fprintf('Feature count: %d/%d\n', i, numel(featureList))
    
    % Set the features to use
    obj.setFeatureMat(featureList{i});

    % By passing dataIdx we make sure all feature sets use the same fold
    [correctFracMean(i),correctFracSD(i), correctFrac(i,:), ...
     classifiedAsID(:,:,i),corrFlag(:,:,i)] = ...
        obj.benchmark(nBootstrap,dataIdx);
    
  end

  % Now to rate the features, we do it in two ways.
  
  % 1. List top 30 feature set combinations
  
  [sortVal,sortIdx] = sort(correctFracMean,'descend');
  
  nTop = 30;
  
  for i = 1:nTop
    sIdx = sortIdx(i);
    
    fprintf('%d. %.3f +/- %.3f : %s\n', ...
            i, correctFracMean(sIdx), ...
            correctFracSD(sIdx), ...
            featureListStr(featureList{sIdx}))
  end
  
  % 2. Tally up the points for the features

  scoreBoard = zeros(numel(obj.allFeatureNames),1);
  
  % Using the idx instead of names, to make it easier
  for i = 1:numel(featureIdxList)
    for j = 1:numel(featureIdxList{i})

      fIdx = featureIdxList{i}(j);
      nFeat = numel(featureIdxList{i});
      
      scoreBoard(fIdx) = scoreBoard(fIdx) + correctFracMean(i) / nFeat;
      
    end
    
  end

  [~,sbIdx] = sort(scoreBoard,'descend');
  
  disp('Score board, feature importance weighted')
  for i = 1:numel(obj.allFeatureNames)
    
    fprintf('%d. Score: %.3f : %s\n', i, scoreBoard(sbIdx(i)), ...
            obj.allFeatureNames{sbIdx(i)})
    
  end
  
  % Do an alternative scoreboard, with just using the top 30
  % feature sets
  topScoreBoard = zeros(numel(obj.allFeatureNames),1);
  
  [cFracMean,topIdx] = sort(correctFracMean,'descend');
  
  for i = 1:nTop
    listIdx = topIdx(i);
    
    for j = 1:numel(featureIdxList{listIdx})
    
      fIdx = featureIdxList{listIdx}(j);
      topScoreBoard(fIdx) = topScoreBoard(fIdx) + correctFracMean(i) / nFeat;
          
    end
      
  end
  
  [~,tsbIdx] = sort(topScoreBoard,'descend');
  
  fprintf('Score board (only from top %d entries), feature importance weighted\n',nTop)
  for i = 1:numel(obj.allFeatureNames)
    
    fprintf('%d. Score: %.3f : %s\n', i, topScoreBoard(tsbIdx(i)), ...
            obj.allFeatureNames{tsbIdx(i)})
    
  end
  

  allFeatureNames = obj.allFeatureNames;
      
  fName = sprintf('chooseFeature-results-%.5f.mat',now());
  
  % Use corrFlag to see if there are any of the RGC that are always wrong
  
  obj.setFeatureMat(allFeatureNames);
  
  featureMat = obj.featureMat;
  RGCtypeID = obj.RGCtypeID;
  RGCtypeName = obj.RGCtypeName;
  
  try
    save(fName, ...
         'correctFrac', 'correctFracMean', 'correctFracSD', ...
         'featureList', 'featureIdxList', ...
         'allFeatureNames', ...
         'scoreBoard', 'sbIdx', ...
         'topScoreBoard', 'tsbIdx', ...
         'classifiedAsID','corrFlag', ...
         'featureMat', 'RGCtypeID','RGCtypeName',...
         'fileNames','fileDirs');
    
  catch e
    getReport(e)
    keyboard
  end
    
  fprintf('Wrote data to %s\n', fName)
  
  toc
  
  keyboard
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function appendLoop(preIdx,nDeep)
    
    if(isempty(preIdx))
      featureIdxList = {};
    end
    
    if(numel(preIdx) < nDeep)

      if(isempty(preIdx))
        maxPreIdx = 0;
      else
        maxPreIdx = max(preIdx);
      end

      availableFeatureIdx = featureIdx(featureIdx > maxPreIdx);
      
      for aIdx = 1:numel(availableFeatureIdx)
        fIdx = [preIdx,availableFeatureIdx(aIdx)];
        featureIdxList{end+1} = fIdx;
        appendLoop(fIdx,nDeep);
      end
      
    end
    
  end

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function featIdx = allFourSets()
    
    featIdx = {};
    
    for i1 = 1:numel(obj.allFeatureNames)
      for i2 = i1+1:numel(obj.allFeatureNames)
        for i3 = i2+1:numel(obj.allFeatureNames)
          for i4 = i3+1:numel(obj.allFeatureNames)
    
            featIdx{end+1} = [i1,i2,i3,i4];
            
          end
        end
      end
    end
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function featIdx = allThreeSets()
    
    featIdx = {};
    
    for i1 = 1:numel(obj.allFeatureNames)
      for i2 = i1+1:numel(obj.allFeatureNames)
        for i3 = i2+1:numel(obj.allFeatureNames)
    
          featIdx{end+1} = [i1,i2,i3];

        end
      end
    end
  end 
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function featNameList = convertToNames(featIdxList)

    featNameList = {};
    
    for fIdx = 1:numel(featIdxList)
      featNameList{end+1} = obj.allFeatureNames(featIdxList{fIdx});
    end
  
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function str = featureListStr(featList)
    
    str = [];
    
    for k = 1:numel(featList)
      if(k == 1)
        str = featList{1};
      else
        str = sprintf('%s, %s', str, featList{k});
      end
    end

  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
  function [fiName,fiDirs] = getFileNames()
    
    fiName = {};
    fiDirs = {};
    
    for i = 1:numel(obj.RGC)
    
      fiName{i} = obj.RGC(i).xmlFile;
      fiDir{i} = obj.RGC(i).xmlDir;
    
    end
      
  end
  
end

