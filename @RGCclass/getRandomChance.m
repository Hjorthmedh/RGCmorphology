function Pcorrect = getRandomChance(obj)

  % This function takes into account the different number of RGC
  % types in the data

  uID = unique(obj.RGCtypeID);
  
  nCells = numel(obj.RGC);
  nOfType = zeros(numel(uID),1);
  
  for i = 1:numel(uID)
    
    nOfType(i) = nnz(obj.RGCtypeID == uID(i));
    
  end
  
  cumN = cumsum(nOfType);

  Pcorrect = sum((nOfType/nCells).^2);

  % To get fraction of each type nOfType/nCells. The probability
  % that a single element from that class is correct is
  % nOfType/nCells. The fraction of elements in total that are of
  % that class is nOfType/nCells. So summing for all classes, and
  % taking into account the size of that class, each class
  % contributes (nOfType/nCells)^2 to the total P.
  
  
end