close all, clear all

fMask = 'SAVE/BestBlind/BestFeaturesForBlindClustering-%d-clusters-17-features.mat';

nClust = 2:9;

for i = 1:numel(nClust)
  data(i) = load(sprintf(fMask,nClust(i)));
end


for i = 1:numel(nClust)

  for j = 1:numel(data(i).silhouetteList)
    nFeatures{i}(j) = numel(data(i).featIdx{j});
  end
  
  for j = 1:data(i).nFeatMax
    idx = find(nFeatures{i} == j);
    
    minSilhouette(i,j) = min(data(i).silhouetteList(idx));
    [maxSilhouette(i,j),mIdx] = max(data(i).silhouetteList(idx));  
    maxIdx(i,j) = idx(mIdx);
    
    medianSilhouette(i,j) = median(data(i).silhouetteList(idx));  
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Interesting that there is a steep dropp in silhouette value after 3 features
% which are the first 3?

for i = 1:numel(nClust)
  featLst = data(i).featIdx{maxIdx(i,3)};
  fprintf('%d clusters: ',nClust(i))
  for j = 1:numel(featLst)
    fprintf('%s ', data(i).allFeatureNames{featLst(j)})
  end
  fprintf('\n')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colors = [254,232,200;
          253,212,158;
          253,187,132;
          252,141,89;
          239,101,72;
          215,48,31;
          179,0,0;
          127,0,0] / 255;

LW = [2 2 2 4 2 2 2 2];

figure
for i = 1:numel(nClust)
  
  p(i) = plot(1:data(i).nFeatMax,medianSilhouette(i,:), ...
              'color', colors(i,:), 'linestyle','-', ...
              'linewidth', LW(i));
  hold on
  % plot(1:data(i).nFeatMax,minSilhouette(i,:), ...
  %     'color', colors(i,:),'linestyle','--');
  plot(1:data(i).nFeatMax,maxSilhouette(i,:), ...
      'color', colors(i,:),'linestyle','--', ...
       'linewidth', LW(i));

  
  pLeg{i} = sprintf('%d cluster', nClust(i));
end

legend(p,pLeg);

ylabel('Silhouette value','fontsize',24)
xlabel('Number of features','fontsize',24)
set(gca,'fontsize',24)

box off

saveas(gcf,'FIGS/BestBlindClustering-silhouette.pdf','pdf')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot along the other axis

color2 = [166,206,227
          31,120,180
          178,223,138
          51,160,44
          251,154,153
          227,26,28
          253,191,111
          255,127,0
          202,178,214
          106,61,154
          255,255,153
          177,89,40]/255;
LS = {'-','--'};

figure
for j = 1:data(1).nFeatMax 
  p2(j) = plot(nClust,maxSilhouette(:,j), ...
            'linewidth', 2, ...
            'linestyle', LS{ceil(j/11)}, ...
            'color', color2(mod(j-1,12)+1,:));
  hold on
  
  pLeg2{j} = sprintf('%d features',j);
end

legend(p2,pLeg2,'location','northeastoutside')
xlabel('Number of clusters','fontsize',24)
ylabel('Silhouette value (max)','fontsize',24)
set(gca,'fontsize',18)
box off


saveas(gcf,'FIGS/BestBlindClustering-silhouette-max.pdf','pdf')



figure
for j = 1:data(1).nFeatMax 
  p2(j) = plot(nClust,medianSilhouette(:,j), ...
            'linewidth', 2, ...
            'linestyle', LS{ceil(j/11)}, ...
            'color', color2(mod(j-1,12)+1,:));
  hold on
  
  pLeg2{j} = sprintf('%d features',j);
end

legend(p2,pLeg2,'location','northeastoutside')
xlabel('Number of clusters','fontsize',24)
ylabel('Silhouette value (median)','fontsize',24)
set(gca,'fontsize',18)
box off


saveas(gcf,'FIGS/BestBlindClustering-silhouette-median.pdf','pdf')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We want to find the feature set that gave the best two cluster and
% five cluster answers, and show the corresponding confusion matrix
% for those two.

[maxVal2,maxIdx2] = max(data(1).silhouetteList);
assert(data(1).nClusters == 2)

feature2 = data(1).allFeatureNames{data(1).featIdx{maxIdx2}};


[maxVal5,maxIdx5] = max(data(4).silhouetteList);
assert(data(4).nClusters == 5)

feature5 = data(4).allFeatureNames{data(4).featIdx{maxIdx5}};
