% First run the choose feature script
%
% Exhaustive test of all 4-tuples.
% r = RGCclass(0); r.lazyLoad();
% r.chooseFeatures();

% This saves a chooseFeature-results-XXX.mat file

clear all, close all

% !! Update to the latest run
% fName = 'chooseFeature-results.mat';
% fName = 'chooseFeature-results-longrun.mat';

%fName = 'chooseFeature-results-735777.65614.mat'; % 3-tuples, small
fName = 'chooseFeature-results-735780.57279.mat'; % 3-tuples, large
% fName = 'chooseFeature-results-735776.22962.mat'; % 4-tuples, big run
load(fName)

nFeat = numel(allFeatureNames);

% Start by looking at the distribution of scores

uCF = unique(correctFrac(:));
N = hist(correctFrac(:),uCF);
bar(uCF,N)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Worse than 60% classification')
[iSet,iRep] = find(correctFrac < 0.6);
badFeatCount = zeros(nFeat,1);

for i = 1:numel(iSet)
  for j = 1:numel(featureIdxList{iSet(i)})
  
    idx = featureIdxList{iSet(i)}(j);
    
    badFeatCount(idx) = badFeatCount(idx) + 1;
    
  end
end

[~,badIdx] = sort(badFeatCount,'descend');

for i = 1:nFeat
  idx = badIdx(i);
  
  fprintf('%d. %d bad counts, %s\n', ...
          i, badFeatCount(idx), allFeatureNames{idx})
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Better than 80 % classification')
[iSet,iRep] = find(correctFrac > 0.8);
goodFeatCount = zeros(nFeat,1);

for i = 1:numel(iSet)
  for j = 1:numel(featureIdxList{iSet(i)})
  
    idx = featureIdxList{iSet(i)}(j);
    
    goodFeatCount(idx) = goodFeatCount(idx) + 1;
    
  end
end

[~,goodIdx] = sort(goodFeatCount,'descend');

for i = 1:nFeat
  idx = goodIdx(i);
  
  fprintf('%d. %d good counts, %s\n', ...
          i, goodFeatCount(idx), allFeatureNames{idx})
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We also want to see which ones are consistently good

sumCF = sum(correctFrac > 0.75,2);

maxIdx = find(sumCF >= max(sumCF)-1);

[~,orderIdx] = sort(correctFracMean(maxIdx),'descend');

for i = 1:numel(maxIdx)
  
  mi = maxIdx(orderIdx(i));
  
  fprintf('#good = %d (mean score %.3f) ', sumCF(mi),mean(correctFrac(mi,:)))
  for j = 1:numel(featureList{mi})
    fprintf('%s ', featureList{mi}{j})
  end
  fprintf('\n')
  
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ok, lets also look at the individual RGC are there any that are
% much more difficult than others to classify

sCF = size(corrFlag);

fracCorr = sum(sum(corrFlag,2),3)/(sCF(2)*sCF(3));

hist(fracCorr,20)
xlabel('Fraction of times correctly classified')
ylabel('Count')

badThresh = 0.2;

badIdx = find(fracCorr < badThresh);

[~,sortBadIdx] = sort(fracCorr(badIdx),'ascend');

fprintf('\n\nCells with are tough to classify\n')

for i = 1:numel(badIdx)
  idx = badIdx(sortBadIdx(i));
  
  fprintf(' %d. %.2f %% correct, File: %s\n', ...
          i, fracCorr(idx)*100,fileNames{idx})
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the really tough cases in feature space to see why they are
% so difficult.

% Features:
%
% Soma area
% Mean terminal segment length --> replace with mean segment length (highly correlated, but more data)
% Density of branch points
% Total dendritic length
% 
% 14 - soma area
% 8 - mean segment length
% 5 - density of branch points
% 16 - total dendritic length

featIdx = [14 8 5 16];

% Hard coded, sine we only defined 5 colours
nID = 5;

typeCol = [228,26,28 ;...
           55,126,184;...
           77,175,74;...
           152,78,163;...
           255,127,0] / 255;


figure

p = [];
pLeg = {};
for iID = 1:nID
  
  idx = find(iID == RGCtypeID);
  
  p(iID) = plot3(featureMat(idx,featIdx(1)), ...
                 featureMat(idx,featIdx(2)), ...
                 featureMat(idx,featIdx(3)), ...
                 '.','color', typeCol(iID,:), ...
                 'markersize', 15);
  
  pLeg{iID} = RGCtypeName{idx(1)};

  hold on
end

% Mark bad cells
for iID = 1:numel(badIdx)

  % Colour it according to the class it is mostly classified as
  cAID = classifiedAsID(badIdx(iID),:,:);
  mostFreqID(iID) = mode(cAID(:));
  
  
  plot3(featureMat(badIdx(iID),featIdx(1)), ...
        featureMat(badIdx(iID),featIdx(2)), ...
        featureMat(badIdx(iID),featIdx(3)), ...
        'o','color', typeCol(mostFreqID(iID),:), ...
        'markersize', 12);

  text(featureMat(badIdx(iID),featIdx(1)), ...
       featureMat(badIdx(iID),featIdx(2)), ...
       featureMat(badIdx(iID),featIdx(3)), ...
       fileNames{badIdx(iID)},'fontsize',3)
  
end

title(sprintf('Marking RGCs missclassified more than %.1f %% of cases', ...
              (1-badThresh)*100))

legend(p,pLeg)
xlabel(allFeatureNames{featIdx(1)})
ylabel(allFeatureNames{featIdx(2)})
zlabel(allFeatureNames{featIdx(3)})

saveas(gcf,'FIGS/Tough-to-classify-feature-space.pdf','pdf')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use PCA on the four features selected

figure

[pc,score,latent] = princomp(featureMat(:,featIdx));

p = [];
pLeg = {};
for iID = 1:nID
  
  idx = find(iID == RGCtypeID);
  
  p(iID) = plot3(score(idx,1), ...
                 score(idx,2), ...
                 score(idx,3), ...
                 '.','color', typeCol(iID,:), ...
                 'markersize', 15);
  
  pLeg{iID} = RGCtypeName{idx(1)};

  hold on
end

% Mark bad cells
for iID = 1:numel(badIdx)

  % Colour it according to the class it is mostly classified as
  cAID = classifiedAsID(badIdx(iID),:,:);
  mostFreqID(iID) = mode(cAID(:));
  
  
  plot3(score(badIdx(iID),1), ...
        score(badIdx(iID),2), ...
        score(badIdx(iID),3), ...
        'o','color', typeCol(mostFreqID(iID),:), ...
        'markersize', 12);

  
  text(score(badIdx(iID),1), ...
       score(badIdx(iID),2), ...
       score(badIdx(iID),3), ...
       fileNames{badIdx(iID)},'fontsize',3)
  
end

legend(p,pLeg)

xlabel('PCA #1')
ylabel('PCA #2')
zlabel('PCA #3')

title(sprintf('Marking RGCs missclassified more than %.1f %% of cases (PCA from 4 features)', ...
              (1-badThresh)*100))

view(0,90)

saveas(gcf,'FIGS/Tough-to-classify-PCA-space.pdf','pdf')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use PCA on the four features selected

figure

[pc,score,latent] = princomp(featureMat);

p = [];
pLeg = {};
for iID = 1:nID
  
  idx = find(iID == RGCtypeID);
  
  p(iID) = plot3(score(idx,1), ...
                 score(idx,2), ...
                 score(idx,3), ...
                 '.','color', typeCol(iID,:), ...
                 'markersize', 15);
  
  pLeg{iID} = RGCtypeName{idx(1)};

  hold on
end

% Mark bad cells
for iID = 1:numel(badIdx)

  % Colour it according to the class it is mostly classified as
  cAID = classifiedAsID(badIdx(iID),:,:);
  mostFreqID(iID) = mode(cAID(:));
  
  
  plot3(score(badIdx(iID),1), ...
        score(badIdx(iID),2), ...
        score(badIdx(iID),3), ...
        'o','color', typeCol(mostFreqID(iID),:), ...
        'markersize', 12);

  
  text(score(badIdx(iID),1), ...
       score(badIdx(iID),2), ...
       score(badIdx(iID),3), ...
       fileNames{badIdx(iID)},'fontsize',3)
  
end

legend(p,pLeg)

xlabel('PCA #1')
ylabel('PCA #2')
zlabel('PCA #3')

title(sprintf('Marking RGCs missclassified more than %.1f %% of cases (PCA from all features)', ...
              (1-badThresh)*100))

view(0,90)

saveas(gcf,'FIGS/Tough-to-classify-full-PCA-space.pdf','pdf')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% addpath('sparsePCA')
% 
% card = 4;
% [cards,vars,Z]= sparsePCA(featureMat,card)
%