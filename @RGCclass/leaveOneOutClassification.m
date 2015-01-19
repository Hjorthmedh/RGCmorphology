function predictedID = leaveOneOutClassification(obj)

  predictedID = zeros(numel(obj.RGC),1);

  for i = 1:numel(obj.RGC)
    
    trainIdx = setdiff(1:numel(obj.RGC),i);
    testIdx = i;
    
    obj.train(trainIdx);
    
    predictedID(testIdx) = obj.classify(testIdx);
    
  end

end
