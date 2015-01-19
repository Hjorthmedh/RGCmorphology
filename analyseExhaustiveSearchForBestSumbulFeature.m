close all, clear all

dataSet = 'Sumbul';
% dataSet = 'Iris';

switch(dataSet)
  case 'Sumbul'
    data = load('RESULTS/Sumbul-exhaustive-blind-clustering-search.mat');
  case 'Iris'
    data = load('RESULTS/Iris-verification-exhaustive-blind-clustering-search.mat');
  otherwise
    fprintf('Unkown dataset: %s\n', dataSet)
    return
end
    
r = data.r;

maxScore = max(data.allScoreList(:));
[iFeat,iNum] = find(maxScore == data.allScoreList);

switch(dataSet)
  case 'Sumbul'
    assert(numel(iFeat) == 1)
  case 'Iris'
    disp('Using only one of the two best feature sets')
    useIdx = 1;
    iFeat = iFeat(useIdx);
    iNum = iNum(useIdx);
  otherwise
    disp('Unknown dataset')
    return 
end
fprintf('%d features: ', numel(data.allFeatureList{iFeat}))
for i = 1:numel(data.allFeatureList{iFeat})
  fprintf('%s ', data.featureNames{data.allFeatureList{iFeat}(i)})
end
fprintf('\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nBins = 50;

figure, hist(data.allScoreList(:),nBins)
xlabel('Rand Score')
ylabel('Count')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot all scores sorted by number of clusters

if(0)
  % figure
  for i = 1:size(data.allScoreList,2)
    figure
    %subplot(size(data.allScoreList,2),1,i)
    hist(data.allScoreList(:,i),nBins)
    xlabel('Rand Score')
    ylabel('Count')
    title(sprintf('%d clusters', data.nClusterRange(i)))
    a = axis(); a(2) = 800; axis(a);  
  end
end

% Plot all scores sorted by number of features


if(0)
  nFeatures = zeros(numel(data.allFeatureList),1);

  for i = 1:numel(data.allFeatureList)
    nFeatures(i) = numel(data.allFeatureList{i});
  end

  nFeatUnique = unique(nFeatures);
  % figure
  for i = 1:numel(nFeatUnique)
    figure
    % subplot(numel(nFeatUnique),1,i)
    idx = find(nFeatures == nFeatUnique(i));
    histData = data.allScoreList(idx,:);
    hist(histData(:),nBins)
    xlabel('Rand Score')
    ylabel('Count')
    title(sprintf('%d features', nFeatUnique(i)))
    a = axis(); a(2) = 800; axis(a);
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

realLabel = r.RGCtypeID(data.knownIdx);
predictedLabel = squeeze(data.allClusterList(iFeat,iNum,data.knownIdx));

% Confusion matrix
confMat = zeros(max(realLabel),max(predictedLabel));

for i = 1:numel(realLabel)
  confMat(realLabel(i),predictedLabel(i)) = ...
      confMat(realLabel(i),predictedLabel(i)) + 1;
end

for i = 1:size(confMat,1)
  if(sum(confMat(i,:)) == 0)
    % Skip this line, no data points
    continue
  end
  

  fprintf('%s:\t', r.RGCtypeName{find(r.RGCtypeID == i,1)})

  for j = 1:size(confMat,2)
    fprintf('%2d ', confMat(i,j))
  end
  
  fprintf('\n')
  
end

nonEmptyIdx = [];
cellType = {};
for i = 1:size(confMat,1)
  if(sum(confMat(i,:)) > 0)
    cellType{end+1} = r.RGCtypeName{find(r.RGCtypeID == i,1)};
    nonEmptyIdx(end+1,1) = i;
  end
end

titleCell = {}
for i = 1:size(confMat,2)
  titleCell{i} = num2str(i);
end

latexStr = makeLatexTable(titleCell, ...
                          cellType, ...
                          confMat(nonEmptyIdx,:),'%d');

fid = fopen('RESULTS/Sumbul-k-means-optimizes-blind.tex','w');
fprintf(fid,strrep(latexStr,'\','\\'));
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% List the ten best sets --- both those when summing all k-means
% clusterings (for different k), and when just counting the best k-maens clustering
%

disp(' ')
disp('Evaluating the features based on the summed score for all different k')

[sortedVal,sortedIdx] = sort(sum(data.allScoreList,2),'descend');

for i = 1:10
  fprintf('Total score: %d, %s', sortedVal(i), data.featureNames{data.allFeatureList{sortedIdx(i)}(1)})
  
  for j = 2:numel(data.allFeatureList{sortedIdx(i)})
    fprintf(', %s', data.featureNames{data.allFeatureList{sortedIdx(i)}(j)})
  end
  
  fprintf('\n')
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
disp('Evaluating the features based on the best k choice')

[sortedValOne,sortedIdxOne] = sort(data.allScoreList(:),'descend');

for i = 1:10
  
  groupPos = find(sortedIdx == sortedIdxOne(i));
  
  [iFeat,iK] = ind2sub(size(data.allScoreList),sortedIdxOne(i));
  
  fprintf('Best score: %d (%d pos:%d), %s', sortedValOne(i), ...
          sortedVal(groupPos), groupPos, ...
          data.featureNames{data.allFeatureList{sortedIdxOne(i)}(1)})
  
  for j = 2:numel(data.allFeatureList{sortedIdxOne(i)})
    fprintf(', %s', data.featureNames{data.allFeatureList{sortedIdxOne(i)}(j)})
  end
  
  fprintf('\n')
  
  
end






