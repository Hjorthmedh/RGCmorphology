% This function atempts to cluster the neurons blind to any
% knowledge about the staining and corresponding typeID.
%
% It uses k-means to cluster
%

function clusterID = blindClustering(obj,k,reps,RGCidx)

  if(~exist('k') | isempty(k))
    k = 5;
  end
  
  if(~exist('reps'))
    reps = 1000;
  end
  
  if(~exist('RGCidx') | isempty(RGCidx))
    RGCidx = 1:numel(obj.RGC);
  end
  
  
  % We need to adjust mean and variance of the features
  % It should already be done, but just in case!
  obj.normaliseFeatureMat();
  
  clusterID = kmeans(obj.featureMat(RGCidx,:), k,'replicates',reps);

  % [obj.RGCtypeID clusterID]
  
end