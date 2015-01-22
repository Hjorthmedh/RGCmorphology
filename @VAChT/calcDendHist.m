function stratificationDepth = calcDendHist(obj,useDiameter)

  % Just a double check, if true will plot histogram from the exact
  % calculation, and from an approximation. They should almost match.
  debugFunk = false;
  
  if(~exist('useDiameter'))
    useDiameter = false;
  end
  
  % Calculates the histogram for the dendrites along the plane-normal axis

  v = obj.planeNormal;

  assert(~isempty(obj.VAChTbinCenters))

  if(~obj.optimizePlane & obj.nBins == numel(obj.rgc.zCoordsXML))

    minCoord = min(min(obj.rgc.zCoordsXML),obj.rgc.parseDendrites(@minZCoord));
    maxCoord = max(max(obj.rgc.zCoordsXML),obj.rgc.parseDendrites(@maxZCoord));

    % Set the new centers
    obj.dendbinCenters = linspace(minCoord,maxCoord,obj.nBins);
    obj.dendHist = zeros(obj.nBins,1);
    
  else
    obj.dendHist = zeros(obj.nBins,1);
    obj.dendbinCenters = linspace(obj.rgc.parseDendrites(@minZCoord), ...
                                  obj.rgc.parseDendrites(@maxZCoord), ...
                                  obj.nBins);
  end
  
  binWidth = abs(mean(diff(obj.dendbinCenters)));
  
  
  % Calculate our resutls
  obj.dendHist = obj.rgc.parseDendrites(@dendHist);

  % Used the max in the histogram before, now changed to centre of mass
  % [~,idx] = max(obj.dendHist);
  % stratificationDepth = obj.dendEdges(idx);
  
  stratificationDepth = obj.rgc.parseDendrites(@centreOfMass);
  stratificationDepth = stratificationDepth(1); % Only keep first value

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function res = minZCoord(branch,res)

    coords = branch.coords;
    coords(:,1) = coords(:,1) - obj.rgc.xSoma;
    coords(:,2) = coords(:,2) - obj.rgc.ySoma;    
    coords(:,3) = coords(:,3) - obj.rgc.zSoma;    

    
    if(isempty(res))
      res = min(coords*v);
    else
      res = min(res,min(coords*v,[],1));
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function res = maxZCoord(branch,res)

    coords = branch.coords;
    coords(:,1) = coords(:,1) - obj.rgc.xSoma;
    coords(:,2) = coords(:,2) - obj.rgc.ySoma;        
    coords(:,3) = coords(:,3) - obj.rgc.zSoma;    
    
    if(isempty(res))
      res = max(coords*v);
    else
      res = max(res,max(coords*v,[],1));
    end

  end
  
  altHist = [];
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function res = dendHist(branch,res)
    
    if(isempty(res))
      res = zeros(size(obj.dendHist));
      altHist = zeros(size(obj.dendHist));
    end
           
    x = branch.coords(:,1) - obj.rgc.xSoma;
    y = branch.coords(:,2) - obj.rgc.ySoma;
    z = branch.coords(:,3) - obj.rgc.zSoma;
    
    if(useDiameter)
      d = branch.diameter;
    else
      % I saw some problems with thick branches close to soma
      % dominating the tracing.
      d = ones(size(branch.diameter));
    end
    
    % Calculate depth along the surface normal
    zAlt = [x,y,z] * v;
        
    for i = 1:numel(x)-1
    
      % Mass of each line segment
      len = sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2 + (z(i)-z(i+1))^2);
      totalMass = len * pi/4*( d(i)^2 + d(i+1)^2 ) / 2; 
      % last /2 to get average diameter
    
      zLen = abs(zAlt(i)-zAlt(i+1));
      
      if(zLen == 0)
        % No z-extent, put all in same bin
        idx = round(1 + (zAlt(i) - obj.dendbinCenters(1))/binWidth);
        % idx = round(0.5 + (obj.nBins-1)*((zAlt(i)-obj.dendbinCenters(1)) ...
        %                                 / (obj.dendbinCenters(end)-obj.dendbinCenters(1))));
        % idx = find(obj.dendEdges(1:end-1) <= zAlt(i) & zAlt(i) <= obj.dendEdges(2:end),1,'first');
        res(idx) = res(idx) + totalMass;
        
        % Double check
        try
          assert(numel(idx) == 1);
        catch e
          getReport(e)
          keyboard
        end
          
      else
        
        binHalfWidth = abs(obj.dendbinCenters(2)-obj.dendbinCenters(1))/2;
        
        % Place the total mass in the appropriate bins
        minZ = min(zAlt(i),zAlt(i+1));
        maxZ = max(zAlt(i),zAlt(i+1));
        
        idxMin = find(obj.dendbinCenters-binHalfWidth < minZ,1,'last');
        idxMax = find(maxZ <= obj.dendbinCenters+binHalfWidth,1,'first');
        
        if(idxMin == idxMax)
          % Only one bin to put it in
          res(idxMin) = res(idxMin) + totalMass;

          % % This is just a extra check, remove this code later
          % try
          %   altCalcIdx = round(1 + (minZ - min(obj.dendbinCenters)) / (2*binHalfWidth));
          %   assert(idxMin == altCalcIdx)
          % catch e
          %   getReport(e)
          %   keyboard
          % end
            
        else
          
          % Several bins, figure it out
          idx = idxMin:idxMax;
          frac = ones(numel(idx),1); % How much to put in each bin
        
          if(isempty(idx))
            disp('This should not happen 2!')
            keyboard
          end
        
          frac(1) = abs(minZ-(obj.dendbinCenters(idxMin)+binHalfWidth))/(2*binHalfWidth);
          frac(end) = abs(maxZ-(obj.dendbinCenters(idxMax)-binHalfWidth))/(2*binHalfWidth);
        
          % Just a precaution
          try
            assert(all(frac <= 1))
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
        [~,minIdx] = min(abs(zAvg - obj.dendbinCenters));
        altHist(minIdx) = altHist(minIdx) + totalMass;
      end
        
    end
      
    if(debugFunk)
      figure, plot(obj.dendbinCenters,res,'k-', ...
                   obj.dendbinCenters,altHist,'r-')
      keyboard
    end
    
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function res = centreOfMass(branch,res)
    
    if(isempty(res))
      res = zeros(3,1);
    end
    
    x = branch.coords(:,1) - obj.rgc.xSoma;
    y = branch.coords(:,2) - obj.rgc.ySoma;
    z = branch.coords(:,3) - obj.rgc.zSoma;
    
    % Transformed coordinates, along plane normal
    coord = [x,y,z] * v;
    assert(size(coord,2) == 1)
    
    if(useDiameter)
      d = branch.diameter;
    else
      % I saw some problems with thick branches close to soma
      % dominating the tracing.
      d = ones(size(branch.diameter));
    end

    for i = 1:numel(x) - 1
      % Use untransformed coordinates to calculate weight
      len = sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2 + (z(i)-z(i+1))^2);
      weight = len * pi/4*( d(i)^2 + d(i+1)^2 ) / 2;      
      
      res(2) = res(2) + weight*(coord(i) + coord(i+1))/2;
      res(3) = res(3) + weight;

      % Centre of mass
      res(1) = res(2) / res(3);
      
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end