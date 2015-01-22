function [dUpper,dLower] = calcVAChTHist(obj,fracOfPeak)

  useFull = true;
  
  % Calculates the histogram along the plane-normal axis

  % Get direction vector
  v = obj.planeNormal;
  
  if(useFull)
    try
      c = (obj.X(:) - obj.rgc.xSoma)*v(1) ...
          + (obj.Y(:) - obj.rgc.ySoma)*v(2) ...
          + (obj.Z(:) - obj.rgc.zSoma)*v(3);
    catch e
      getReport(e)
      keyboard
    end
  else
  
    % Xr, Yr, Zr coordinates for imgR, which is a downscaled
    % (reduced) version of the VAChT band channel of the z-stack
    % Here c is centred on the top of the soma
  
    c = (obj.Xr(:) - obj.rgc.xSoma)*v(1) ...
        + (obj.Yr(:) - obj.rgc.ySoma)*v(2) ...
        + (obj.Zr(:) - obj.rgc.zSoma)*v(3);
  end
    
  % Calculate the histogram
  if(~obj.optimizePlane & ~obj.manualPlaneTilt & obj.nBins == numel(obj.rgc.zCoordsXML))
    obj.VAChTbinCenters = transpose(sort(obj.rgc.zCoordsXML-obj.rgc.zSoma,'ascend'));
    obj.VAChThist = zeros(obj.nBins,1);
  else
    obj.VAChTbinCenters = linspace(min(c),max(c),obj.nBins);
    obj.VAChThist = zeros(obj.nBins,1);
  end
  
  binWidth = abs(mean(diff(obj.VAChTbinCenters)));
  idx = round(1 + (c-min(obj.VAChTbinCenters)) / binWidth);

  try
    assert(all(idx > 0))
  catch e
    getReport(e)
    keyboard
  end
    
  if(useFull)
    img = squeeze(obj.rgc.lsm.image(:,:,obj.VAChTchannel,:));
    
    %% Try an alternative way
    
    % oldTime = now();
    % disp('Summing start')

    % for thisIdx = 1:numel(obj.VAChTedges)
    %   sumIdx = find(idx == thisIdx);
    %   obj.VAChThist(thisIdx) = sum(img(sumIdx));
    % end
    
    % deltaT = (now() - oldTime()) * 3600*24;
    % fprintf('Summing ends: %.1f seconds\n', deltaT)

    %%%
    
    % C code is so fast we dont care anymore
    % oldTime = now();
    % disp('Summing start (C)')
    
    try
      obj.VAChThist = sumImage(double(img(:)), int32(idx(:)), int32(max(idx(:))));
    catch e
      disp(['If the code crashes here, type dbquit, then mex sumImage.c ' ...
            'to generate the mex file.'])
      getReport(e)
      keyboard
    end
      
    % deltaT = (now() - oldTime()) * 3600*24;
    % fprintf('Summing ends (C): %.1f seconds\n', deltaT)
   
    % disp('Check results are same')
    
    % The commented-out version below takes a lot longer to run that the find
    % implementation above. You will fall asleep waiting for it... zzzz...
    %
    % oldTime = now();
    % disp('Summing start')
    
    % for i = 1:numel(idx)
    %   obj.VAChThist(idx(i)) = obj.VAChThist(idx(i)) + img(i);
    % end
    
    % deltaT = (now() - oldTime()) * 3600*24;
    % fprintf('Summing ends: %d seconds\n', deltaT)
    
  else    
    for i = 1:numel(idx)
      obj.VAChThist(idx(i)) = obj.VAChThist(idx(i)) + obj.imgR(i);
    end
  end
  
  % Find peak and use a fraction of it as threshold for upper and
  % lower limit
  
  [maxVal,maxIdx] = max(obj.VAChThist);
  % We are excluding zero bins from min
  minVal = min(obj.VAChThist(obj.VAChThist > 0));  
  
  threshMask = obj.VAChThist >= fracOfPeak * maxVal ...
                                + (1-fracOfPeak) * minVal;
  upperIdx = maxIdx;
  lowerIdx = maxIdx;

  % We want to find the last value that is above threshold, both
  % above and below maxIdx
  for i = maxIdx:-1:1
    if(threshMask(i))
      lowerIdx = i;
    else
      break
    end
  end
  
  for i = maxIdx:1:numel(obj.VAChThist)-1
    if(threshMask(i))
      upperIdx = i+1;
    else
      break;
    end
  end
  
  dLower = obj.VAChTbinCenters(lowerIdx);
  dUpper = obj.VAChTbinCenters(upperIdx);
    
end