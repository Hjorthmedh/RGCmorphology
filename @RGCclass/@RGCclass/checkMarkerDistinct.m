function checkMarkerDistinct(obj)

  % This function takes only the cells with the same genetic marker,
  % and checks if they are distinct.

  obj.setFeatureMat(obj.featuresUsed);
  
  uID = unique(obj.RGCtypeID);
  
  nClusters = 2;
  
  figure

  for i = 1:numel(uID)
    subplot(numel(uID),1,i);
    
    idx = find(obj.RGCtypeID == uID(i));
    
    % Create a subset of the feature matrix, and normalise it
    fm = obj.featureMat(idx,:);
    fm = fm ./ repmat(std(fm),size(fm,1),1);
    fm = fm - repmat(mean(fm),size(fm,1),1);

    clusterID = kmeans(fm, nClusters,'replicates',100);
    
    [s,h] = silhouette(fm,clusterID);
    
    str = sprintf('%s silhouette %.3f', ...
                  obj.RGCtypeName{idx(1)}, ...
                  mean(s));
    
    title(str)

  end

  t = text(0.8,2.5,obj.featuresUsed);
  
  str = sprintf('FIGS/Silhouette-value-on-marked-cells-%d-features.pdf',numel(obj.featuresUsed));
  saveas(gcf,str,'pdf')
  
  obj.plotPCA
  
end