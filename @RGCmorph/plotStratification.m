

function [plotHandle,minZ,maxZ] = plotStratification(obj,normaliseFlag)

  if(~exist('normaliseFlag'))
    normaliseFlag = false;
  end
  
  [stratDepth,biStratDist,debugInfo] = obj.getStratification();

  binCount = debugInfo.dendBinCount;
  binCenter = debugInfo.dendBinCenters;

  if(normaliseFlag)
    binCount = binCount / sum(binCount);
  end
  
  plotHandle = barh(binCenter,binCount);

  if(normaliseFlag)
    ylabel('Z-depth')
    hold on, plot(0,0,'r.','markersize',25)
  else
    xlabel('Count')
    ylabel('Z-depth')
  end
  
  firstIdx = find(binCount,1,'first');
  lastIdx = find(binCount,1,'last');
  
  binEdges = binCenter([firstIdx lastIdx]);
  
  minZ = min(binEdges);
  maxZ = max(binEdges);
  
end
