% This function tries to verify that the Z offset is correct. It
% does so by checking the intensity values at all nodes for a set
% of different Z-depths.

function verifyOffset(obj)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  offsetRange = -50:0.1:50;
    
  zCoords = obj.rgc.zCoordsXML;
  
  morphImg = squeeze(obj.rgc.lsm.image(:,:,obj.morphChannel,:));

  coords = obj.rgc.parseDendrites(@allCoords);
  
  intSum = zeros(numel(offsetRange),1);
  numOutside = zeros(numel(offsetRange),1);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  for i = 1:numel(offsetRange)
    [intSum(i),numOutside(i)] = calculateMatch(coords,offsetRange(i));
  end
  
  [~,maxScoreIdx] = max(intSum);
  noneOutsideIdx = find(numOutside == 0);
  
  [~,compareIdx] = min(abs(offsetRange - obj.rgc.zOffsetXML));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  figure('name',sprintf('Verify offset: %s', obj.rgc.xmlFile))
  subplot(2,1,1)
  plot(offsetRange,intSum,'k', ...
       offsetRange(maxScoreIdx),intSum(maxScoreIdx),'r*', ...
       obj.rgc.zOffsetXML,intSum(compareIdx),'bo');
  xlabel('Z-offset')
  ylabel('Match score')

  if(ismember(maxScoreIdx,noneOutsideIdx))

    str = sprintf('%s: Best offset: %.2f (XML offset %.2f)\n', ...
                  obj.rgc.xmlFile, ...
                  offsetRange(maxScoreIdx), ...
                  obj.rgc.zOffsetXML);
  else
    
    str = sprintf('%s: Offset: %.2f has %d nodes outside LSM (XML offset %.2f)\n', ...
                  obj.rgc.xmlFile, ...
                  offsetRange(maxScoreIdx), ...
                  numOutside(maxScoreIdx), ...
                  obj.rgc.zOffsetXML);
  end

  title(str)
  fprintf(str)
  
  
  subplot(2,1,2)
  plot(offsetRange,numOutside,'k', ...
       offsetRange(noneOutsideIdx),numOutside(noneOutsideIdx),'r*', ...
       obj.rgc.zOffsetXML,numOutside(compareIdx))
  xlabel('Z-offset')
  ylabel('Nodes outside LSM image')
  
  figName = sprintf('FIGS/%s-Z-offset.pdf', obj.rgc.xmlFile);
  saveas(gcf,figName,'pdf')
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function [intensitySum,pointsOutside] = calculateMatch(nodes,zOffset)
    
    dx = obj.x(2) - obj.x(1);
    dy = obj.y(2) - obj.y(1);
    dz = obj.z(2) - obj.z(1);
    
    xIdx = ceil((nodes(:,1) - obj.x(1)) / dx);
    yIdx = ceil((nodes(:,2) - obj.y(1)) / dy);
    zIdx = ceil((nodes(:,3) - obj.z(1) + zOffset) / dz);
    
    % Remove points that are outside the LSM image
    
    okIdx =  find(1 <= xIdx & xIdx <= numel(obj.x) ...
                  & 1 <= yIdx & yIdx <= numel(obj.y) ...
                  & 1 <= zIdx & zIdx <= numel(obj.z));
    
    idx = sub2ind(size(morphImg),yIdx(okIdx),xIdx(okIdx),zIdx(okIdx));
    
    intensitySum = sum(morphImg(idx));
    pointsOutside = numel(xIdx) - numel(okIdx);
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  function res = allCoords(branch, res)

    res = [res; branch.coords];
    
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end