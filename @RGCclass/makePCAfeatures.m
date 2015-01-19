% This function generates PCA features from the features chosen

function makePCAfeatures(obj,nPCA,featuresUsed)

  if(~exist('featuresUsed'))
    featuresUsed = obj.featuresUsed;
  end
  
  nPCA = min(nPCA,numel(featuresUsed));
  
  % First initiate the feature matrix with the features
  obj.setFeatureMat(featuresUsed);
  
  % Generate PCA features
  [pc,score,latent] = princomp(obj.featureMat);

  obj.featureMat = score(:,1:nPCA);
  
end