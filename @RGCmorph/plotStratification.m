

function plotHandle = plotStratification(obj)

  [stratDepth,biStratDist,debugInfo] = obj.getStratification();

  binCount = debugInfo.dendBinCount;
  binCenter = debugInfo.dendBinCenters;

  plotHandle = barh(binCenter,binCount);
  xlabel('Count')
  ylabel('Z-depth')
  
end
