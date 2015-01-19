function verifyOnOtherData(obj)

  data = load('fisheriris');
  
  obj.featureMat = data.meas;
  
  obj.trainingIdx = randperm(size(obj.featureMat,1));
  obj.trainingIdx = obj.trainingIdx(1:90);
  
  obj.featuresUsed = {'Sepal Length','Sepal Width',...
                      'Petal Length','Petal Width'};
  obj.allFeatureNames = obj.featuresUsed;
  
  if(0)
    % Remove some features -- Petal Width alone, can give 95% classification
    keepIdx = [4];
    obj.featuresUsed = obj.featuresUsed{[keepIdx]};
    obj.allFeatureNames = obj.featuresUsed;
    
    obj.featureMat = obj.featureMat(:,keepIdx);
    
  end
  
  testSet = setdiff(1:150,obj.trainingIdx);

  obj.RGC = [];
  obj.RGCtypeID = [];
  
  for i = 1:numel(data.species)

    switch(data.species{i})
      case 'setosa'
        obj.RGC(i).RGCtypeID = 1;
        obj.RGCtypeID(i,1) = 1;
      case 'versicolor'
        obj.RGC(i).RGCtypeID = 2;        
        obj.RGCtypeID(i,1) = 2;      
      case 'virginica'
        obj.RGC(i).RGCtypeID = 3;    
        obj.RGCtypeID(i,1) = 3;        
    end
  end
  
  obj.train();
  
  [group,nCorrAll,nFalseAll] = obj.classify();
  
  fractionCorrect = nnz(group(testSet) == obj.RGCtypeID(testSet))/nnz(testSet);
  
  fprintf('%.2f %% correct of training set, %.2f %% of all.\n', ...
          fractionCorrect*100, nCorrAll/150*100)
  
  figure
  for k = 1:4
    subplot(4,1,k)
    
    for i = 1:3, 
      idx = find(obj.RGCtypeID == i); 
      plot(obj.featureMat(idx,k),i*ones(size(idx))+rand(size(idx))*0.2,'o');
          
      hold all
    end
  end
  
  % keyboard
  
end