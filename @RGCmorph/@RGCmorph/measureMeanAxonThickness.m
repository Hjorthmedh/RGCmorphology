function mt = measureMeanAxonThickness(obj,axonLen)

  % Lets assume there is only one axon
  if(numel(obj.axon) == 1)
    % All good, continue
  else
    if(numel(obj.axon) > 1)
      disp('More than one axon - only using first segment of it')
    else
      disp('No axon found!')
      mt = NaN;
      return
    end
  end
  
  x = obj.axon(1).coords(:,1);
  y = obj.axon(1).coords(:,2);
  z = obj.axon(1).coords(:,3);    
  
  len = sqrt(diff(x).^2 + diff(y).^2 + diff(z).^2);
  
  % Index for the first 50 micrometer of compartments
  idx = find(cumsum(len) <= axonLen);
  
  % Calculate mean thickness, we need to weight it
  % !!! In case of multiple axons, we only use first one
  try
    mt = sum(len(idx)/sum(len(idx)) ...
             .*(obj.axon(1).diameter(idx) + obj.axon(1).diameter(idx+1))/2);
  catch e
    getReport(e)
    keyboard
  end
  
end
  
