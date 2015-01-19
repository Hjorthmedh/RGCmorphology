% To get the feature names use
% obj.allFeatureNames(featureIdx{yourIndexHere})

function featureIdx = getSubsetOfFeatures(obj,nFeatures)

  maxIdx = numel(obj.allFeatureNames);
  if(~exist('nFeatures') | isempty(nFeatures))
    disp('Running a complete exhaustive search!')
    nFeatures = maxIdx;
  end
  
  featureIdx = {};
    
  % Create the base case
  if(isempty(featureIdx) & nFeatures > 0)
      
    for i = 1:maxIdx
      featureIdx{i} = i;
    end
      
    nFeatures = nFeatures - 1;
    firstIdx = 1;
      
  end
    
    
  while(nFeatures > 0)
    
    lastIdx = numel(featureIdx);
      
    for i = firstIdx:lastIdx

      idxStart = max(featureIdx{i}) + 1;
        
      for j = idxStart:maxIdx
          
        featureIdx{end+1} = [featureIdx{i},j];
          
      end
        
    end
      
    nFeatures = nFeatures - 1;
    firstIdx = lastIdx + 1;
    
  end
    
end