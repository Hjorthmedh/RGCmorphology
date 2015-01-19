% This code needs integer labels, and does not include labels 0 or
% below in calculations. Those values can be used to indicate unknowns.

% Note that we use a slight variation of the rand index. We only count
% those pairs where both points are in the same group, in both
% labellings. We do not count the pairs where both points are in
% different groups in the two labellings. See Hubert and Arabie 1985

function RI = randIndex(obj,labelA,labelB)

  % Lets make sure there is nothing funky with the label names
  assert(all(0 < labelA & labelA < 100) & ...
         all(0 < labelB & labelB < 100))
  
  assert(numel(labelA) == numel(labelB))
  
  % Make a table
  maxA = max(labelA);
  maxB = max(labelB);
  
  classMat = zeros(maxA,maxB);
  
  for i = 1:numel(labelA)
    classMat(labelA(i),labelB(i)) = classMat(labelA(i),labelB(i)) + 1;
  end
  
  RI = sum(classMat(:) .* (classMat(:) - 1)) / 2;
  
end
