function [modalClassID,ID] = foldedClassification(obj,kFoldCrossVal,nRep)
  
  ID = zeros(numel(obj.RGC),nRep);
  
  for iN = 1:nRep
    
    % Divide the data into k folds
    foldID = ceil(kFoldCrossVal*rand(numel(obj.RGC),1));
    
    for iF = 1:kFoldCrossVal

      % Use each fold as test set ones
      trainIdx = find(foldID ~= iF);
      testIdx = find(foldID == iF);
      
      obj.setFeatureMat(obj.featuresUsed);
      obj.train(trainIdx);

      ID(testIdx,iN) = obj.classify(testIdx);
      
    end

  end

  % Find the most common classification for each cell
  modalClassID = mode(ID,2);
  
end
  