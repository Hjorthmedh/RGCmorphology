% Uses train and classify and k-folded cross validation

% If you want to specify the folds for the repeats, then supply
% dataIdx which must be integers

% corrFraction = mean of correctFraction
% corrFraction = standard deviation of correctFraction
% correctFraction = fraction of correct classified objects for all
% nRep repeats

% Do not parallellise this function, since it changes internal
% states of the object.

function [corrFraction,corrFractionSD,correctFraction, ...
         classifiedID,correctFlag, mu, sigma, dataIdx] = benchmark(obj,nRep,dataIdx,currentFeatureMatFlag)

  if(~exist('nRep'))
    nRep = 1;
  end
  
  classifiedID = zeros(numel(obj.RGC),nRep);
  correctFlag = NaN*ones(size(classifiedID));
  
  nClass = numel(unique(obj.RGCtypeID));
  nFeat = numel(obj.featuresUsed);
  
  
  if(exist('dataIdx') & ~isempty(dataIdx))
    assert(size(dataIdx,1) == numel(obj.RGC) ...
           & size(dataIdx,2) == nRep)
  
    uIdx = unique(dataIdx);
    kFold = numel(uIdx);
    
    % Make sure all folds are represented
    assert(all(1:kFold == transpose(uIdx)))
    
  else
    dataIdx = [];
    kFold = 5; % 5
  end
  
  if(~exist('currentFeatureMatFlag'))
    currentFeatureMatFlag = 0;
  end
  
  if(~currentFeatureMatFlag)
    if(obj.verbose)
      disp('Resetting feature matrix to features specified in featuresUsed')
    end
    
    % Just make sure we are using the right features
    obj.setFeatureMat(obj.featuresUsed);
  else
    disp('Keeping current feature matrix')
  end

  nCorrTotal = 0;
  nFalseTotal = 0;
  
  nCorrAll = NaN*ones(nRep,1);
  nFalseAll = NaN*ones(nRep,1);

  % Testing to make sure classifier doesnt change too much
  mu = NaN*zeros(nClass,nFeat,nRep,kFold);
  sigma = NaN*zeros(nClass,nFeat,nRep,kFold); 
  
  
  for iRep = 1:nRep
    
    if(obj.verbose)
      fprintf('Rep: %d/%d\n', iRep, nRep)
    end
    
    nC = 0;
    nF = 0;
    
    if(~isempty(dataIdx))
      if(iRep == 1 & obj.verbose)
        disp('Using provided folding of data')
      end
      
      idx = dataIdx(:,iRep);
      
    else
      if(iRep == 1 & obj.verbose)
        disp('Randomizing the folds')
      end
      
      idx = ceil(kFold*rand(numel(obj.RGC),1));
    end
    
    % Loop through the folds
    for i = 1:kFold
  
      trainIdx = find(idx ~= i);
      testIdx = find(idx == i);
      
      obj.train(trainIdx);
      [group, nCorr, nFalse] = obj.classify(testIdx);
  
      try
        classifiedID(testIdx,iRep) = group;
        correctFlag(testIdx,iRep) = (obj.RGCtypeID(testIdx) == group);
      catch e
        getReport(e)
        keyboard
      end
        
      nCorrTotal = nCorrTotal + nCorr;
      nFalseTotal = nFalseTotal + nFalse;
      
      nC = nC + nCorr;
      nF = nF + nFalse;
      
      if(strcmpi(obj.classifierMethod,'NaiveBayes'))
        try
          [mu(:,:,iRep,i),sigma(:,:,iRep,i)] = obj.getNaiveBayesParams();
        catch e
          getReport(e)
          keyboard
        end
      end
        
    end
    
    nCorrAll(iRep) = nC;
    nFalseAll(iRep) = nF;
    
  end
  
  correctFraction = nCorrAll ./ (nCorrAll + nFalseAll);

  if(obj.verbose)
    fprintf('%d-fold cross-validation: %.1f +/- %.1f %% correct\n', ...
            kFold, mean(correctFraction)*100, std(correctFraction)*100)
  
    fprintf('%d-fold cross-validation: %.1f %% correct\n', ...
            kFold, nCorrTotal/(nCorrTotal + nFalseTotal) * 100)
  end
  
  corrFraction = mean(correctFraction);
  corrFractionSD = std(correctFraction);
  
end