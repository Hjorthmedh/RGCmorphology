function SM = shuffledFeatureMat(obj,type)

  SM = zeros(size(obj.featureMat));

  switch(type)
    
    case 'shuffleWithinRows'
      for i = 1:size(obj.featureMat,2)
        SM(:,i) = obj.featureMat(randperm(size(obj.featureMat,1)),i);
      end
      
    case 'shuffleWithinColumns'
      for i = 1:size(obj.featureMat,1)
        SM(i,:) = obj.featureMat(i,randperm(size(obj.featureMat,2)));
      end
      
    case 'shuffleAll'
      SM = reshape(obj.featureMat(randperm(numel(obj.featureMat))),size(obj.featureMat));
      
    otherwise
      fprintf('Unknown shuffle option: %s\n', type)
      keyboard
  
  end
  
end
