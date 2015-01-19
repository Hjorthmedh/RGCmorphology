% If nBins is not given then binWidth can be used to calculate the
% number of bins, otherwise binWidth is ignored.
% minEdge, maxEdge can be used to set a upper/lower bound on the
% edges, ie those parameters can increase but never reduce the size.
%
% Please note this function centers axis around soma (to be able to
% do rotations if needed). 

function [dendBinCount,dendBinCenters] = calcDendHist(obj,zAxis,nBins,minEdge,maxEdge,binWidth)

  debugFunk = false;
  useDiameter = false;

  if(~exist('zAxis') || isempty(zAxis))
    zAxis = [0; 0; 1];
  end
  
  minCoord = obj.parseDendrites(@minZCoord);
  maxCoord = obj.parseDendrites(@maxZCoord);  
  
  % Allow the user to override the options
  if(exist('minEdge') && ~isempty(minEdge))
    minCoord = min(minCoord,minEdge);
  end
  
  if(exist('maxEdge') && ~isempty(maxEdge))
    maxCoord = max(maxCoord,maxEdge);
  end

  if(~exist('nBins') || isempty(nBins))
    
    if(exist('binWidth') & ~isempty(binWidth))
      nBins = round((maxCoord - minCoord)/binWidth) + 1;
      if(nBins <= 1)
        disp('calcDendHist: Something is fishy')
        keyboard
      end
    else
      disp('nBins not given')
      keyboard
      nBins = 50;
    end
  end

  try
    dendBinCount = zeros(nBins,1);
    dendBinCenters = transpose(linspace(minCoord,maxCoord,nBins));
    
    binWidth = abs(mean(diff(dendBinCenters)));

    dendBinCount = obj.parseDendrites(@dendHist);
  catch e
    getReport(e)
    keyboard
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function res = minZCoord(branch,res)

    coords = branch.coords;
    coords(:,1) = coords(:,1) - obj.xSoma;
    coords(:,2) = coords(:,2) - obj.ySoma;    
    coords(:,3) = coords(:,3) - obj.zSoma;    

    
    if(isempty(res))
      res = min(coords*zAxis);
    else
      res = min(res,min(coords*zAxis,[],1));
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function res = maxZCoord(branch,res)

    coords = branch.coords;
    coords(:,1) = coords(:,1) - obj.xSoma;
    coords(:,2) = coords(:,2) - obj.ySoma;        
    coords(:,3) = coords(:,3) - obj.zSoma;    
    
    if(isempty(res))
      res = max(coords*zAxis);
    else
      res = max(res,max(coords*zAxis,[],1));
    end

  end
  
  altHist = [];
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  function res = dendHist(branch,res)
    
    if(isempty(res))

      res = zeros(nBins,1); % nBins defined earlier

      altHist = zeros(nBins,1);       % This variable is used to verify our results
    end
           
    x = branch.coords(:,1) - obj.xSoma;
    y = branch.coords(:,2) - obj.ySoma;
    z = branch.coords(:,3) - obj.zSoma;
    
    if(useDiameter)
      d = branch.diameter;
    else
      % I saw some problems with thick branches close to soma
      % dominating the tracing.
      d = ones(size(branch.diameter));
    end
    
    % Calculate depth along the surface normal
    zAlt = [x,y,z] * zAxis;
        
    for i = 1:numel(x)-1
    
      % Mass of each line segment
      len = sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2 + (z(i)-z(i+1))^2);
      totalMass = len * pi/4*( d(i)^2 + d(i+1)^2 ) / 2; 
      % last /2 to get average diameter
    
      zLen = abs(zAlt(i)-zAlt(i+1));
      
      if(zLen == 0)
        % No z-extent, put all in same bin
        idx = round(1 + (zAlt(i) - dendBinCenters(1))/binWidth);
        res(idx) = res(idx) + totalMass;
        
        % Double check
        try
          assert(numel(idx) == 1);
        catch e
          getReport(e)
          keyboard
        end
          
      else

        binHalfWidth = abs(dendBinCenters(2)-dendBinCenters(1))/2;
        
        % Place the total mass in the appropriate bins
        minZ = min(zAlt(i),zAlt(i+1));
        maxZ = max(zAlt(i),zAlt(i+1));
        
        idxMin = find(dendBinCenters-binHalfWidth < minZ,1,'last');
        idxMax = find(maxZ <= dendBinCenters+binHalfWidth,1,'first');
        
        if(idxMin == idxMax)
          % Only one bin to put it in
          res(idxMin) = res(idxMin) + totalMass;

        else
          
          % Several bins, figure it out
          idx = idxMin:idxMax;
          frac = ones(numel(idx),1); % How much to put in each bin
        
          if(isempty(idx))
            disp('This should not happen 2!')
            keyboard
          end
        
          frac(1) = abs(minZ-(dendBinCenters(idxMin)+binHalfWidth))/(2*binHalfWidth);
          frac(end) = abs(maxZ-(dendBinCenters(idxMax)-binHalfWidth))/(2*binHalfWidth);
        
          % Just a precaution
          try
            assert(all(frac <= 1+1e-9))
          catch e
            disp('This should not happen')
            getReport(e)
            keyboard
          end
          
          frac = frac/sum(frac);
          try
            res(idx) = res(idx) + frac*totalMass;
          catch e
            getReport(e)
            keyboard
          end
        end
      end
      
      
      %%% This is a double check
      if(debugFunk)
        zAvg = (zAlt(i) + zAlt(i+1)) / 2;
        [~,minIdx] = min(abs(zAvg - dendBinCenters));
        altHist(minIdx) = altHist(minIdx) + totalMass;
      end
        
    end
      
    if(debugFunk)
      figure, plot(dendBinCenters,res,'k-', ...
                   dendBinCenters,altHist,'r-')
      disp('Debugfig plotted')
      keyboard
    end
    
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  
  
end