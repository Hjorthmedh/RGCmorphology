function [kBest,clusterID] = optimizeBlindClusterNumber(obj,kRange)

  disp('Consider using blindClusteringBatch.m instead')
  
  if(~exist('kRange'))
    kRange = 2:10;
  end

  sil = zeros(numel(kRange),1);
  
  clusterIDall = [];
  
  figure
  
  for i = 1:numel(kRange)
    
    subplot(ceil(numel(kRange)/2),2,i)
    k = kRange(i);
    
    clusterID = obj.blindClustering(k);
    clusterIDall{i} = clusterID;
    
    [s,h] = silhouette(obj.featureMat,clusterID);
  
    minSil(i) = min(s);
    meanSil(i) = mean(s);
    title(sprintf('k = %d, min silhouette = %.3f (mean %.3f)', k, minSil(i),meanSil(i)));
    
    fprintf('k = %d, min silhouette = %.3f (mean %.3f)', k, minSil(i),meanSil(i))
    
  end
  
  [~,maxIdx] = max(meanSil);
  
  kBest = kRange(maxIdx);
  clusterID = clusterIDall{i};
  
  saveas(gcf,'FIGS/Silhouette-value-for-blind-clustering.pdf','pdf')
  
end