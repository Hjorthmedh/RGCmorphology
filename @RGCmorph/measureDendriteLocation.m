% Quantifies location of the dendritic mass relative to the VAChT bands

function [zA,zB,dendHistBins,dendHistEdges] = ...
      measureDendriteLocation(obj, percentileA, percentileB, useScaled)
    
  if(~exist('useScaled') | isempty(useScaled))
    useScaled = true;
  end
  
  if(useScaled)
    res = obj.parseDendrites(@obj.measureZdistribVAChTcoordsScaled);

    dendHistEdges = res{1};
    dendHistBins = res{2};
  else
    res = obj.parseDendrites(@obj.measureZdistribVAChToffset);

    dendHistEdges = res{1};
    dendHistBins = res{2}; 
  end
    
  % We now want to find the 20% and 80% percentiles to establish
  % extent of dendritic arbors
   
  cSum = cumsum(dendHistBins);
    
  idxA = find(cSum <= cSum(end)*percentileA,1,'last');
  idxB = find(cSum <= cSum(end)*percentileB,1,'last');    
    
  if(isempty(idxA))
    idxA = 1;
  end
    
  if(isempty(idxA) | isempty(idxB))
    disp('analyse: dendriteLocation: idxA or idxB empty')
    keyboard
  end
    
  zA = dendHistEdges(idxA);
  zB = dendHistEdges(idxB);
  
end
