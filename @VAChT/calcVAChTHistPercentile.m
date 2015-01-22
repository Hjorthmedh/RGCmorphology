function [dUpper,dLower] = calcVAChTHist(obj,lowPer,highPer)

  % Calculates the histogram along the plane-normal axis

  % Get direction vector
  v = obj.planeNormal;
  
  % Xr, Yr, Zr coordinates for imgR, which is a downscaled
  % (reduced) version of the VAChT band channel of the z-stack
  % Here c is centred on the top of the soma
  
  c =   (obj.Xr(:) - obj.rgc.xSoma)*v(1) ...
      + (obj.Yr(:) - obj.rgc.ySoma)*v(2) ...
      + (obj.Zr(:) - obj.rgc.zSoma)*v(3);
  
  % keyboard
  
  obj.VAChTedges = linspace(min(c),max(c),obj.nBins);
  obj.VAChThist = zeros(obj.nBins,1);
  
  idx = ceil(obj.nBins*((c - min(c)) / (max(c) - min(c))));
  idx(find(idx == 0)) = 1;
    
  for i = 1:numel(idx)
    obj.VAChThist(idx(i)) = obj.VAChThist(idx(i)) + obj.imgR(i);
  end
  
  % lowZ and highZ are used to auto-detect VAChT-band locations
  
  if(isempty(lowPer))
    % If lower percentil not given, then we use the same absolute
    % threshold as the one calculated for the higher one
    disp('Matching threshold for lower VAChT band')

    cSum = cumsum(obj.VAChThist);
    highIdx = find(cSum >= highPer*cSum(end),1,'first');    
    dUpper = obj.VAChTedges(highIdx);
    
    thresh = obj.VAChThist(highIdx);
    % Ignore empty bins
    
    lowIdx = find(obj.VAChThist(1:highIdx) >= thresh,1,'first');
    dLower = obj.VAChTedges(lowIdx);
    
    
  else
  
    cSum = cumsum(obj.VAChThist);
    lowIdx = find(cSum <= lowPer*cSum(end),1,'last');
    highIdx = find(cSum >= highPer*cSum(end),1,'first');
  
    dLower = obj.VAChTedges(lowIdx);
    dUpper = obj.VAChTedges(highIdx);
    
  end
  
end