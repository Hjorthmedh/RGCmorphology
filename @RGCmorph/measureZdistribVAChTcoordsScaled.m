% Creates a histogram of the distribution of dendritic mass along
% the Z-axis. The z-coordinate system are here scaled to be 0 and 1
% at the two VAChT bands. The "mass" of each segment is calculated
% before doing the scaling to avoid distortions.
%
% First cell returned is edges, second cell is binned data

function res = measureZdistribVAChTcoordsScaled(obj,branch,res)

  if(isempty(res))
    nBins = 1000;
    ZedgesAlt = linspace(-10,10,nBins);
    res{1} = ZedgesAlt;                 % edges
    res{2} = zeros(1,numel(ZedgesAlt));       % binned data
  end
      
  % Note that in all calculations we place the total mass of the
  % compartment in the bin specified by the VAChT cooridinate
  % system (zAlt), but we use the original coordinate system to
  % calculate total mass (to avoid distortions).
  
  % We do need to centre coordinate system around soma for the
  % z-coordinates to be correct. - NO WE DONT?
  
  x = branch.coords(:,1) - obj.xSoma;
  y = branch.coords(:,2) - obj.ySoma;
  z = branch.coords(:,3) - obj.zSoma;
  d = branch.diameter;
  
  v = obj.VAChTnormal;
  
  try
    zAlt = ([x,y,z] * v - obj.VAChTdUpper) ...
           / (obj.VAChTdLower - obj.VAChTdUpper);
  catch e
    getReport(e)
    keyboard
  end
    
  for i = 1:numel(x)-1
    try 
      % Calculate the total mass
      len = sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2 + (z(i)-z(i+1))^2);
      totalMass = len * pi/4*( d(i)^2 + d(i+1)^2 )/2;
      
      Zlen = abs(zAlt(i)-zAlt(i+1));
      
      if(Zlen == 0)
        % No Z-extent, put all in same bin
        idx = find(res{1}(1:end-1) <= zAlt(i) & zAlt(i) < res{1}(2:end));
        res{2}(idx) = res{2}(idx) + totalMass;
        
        try
          assert(numel(idx) == 1) % Just a double check
        catch e
          getReport(e)
          keyboard
        end
      else
        % Place the total mass in the appropriate bins
        minZ = min(zAlt(i),zAlt(i+1));
        maxZ = max(zAlt(i),zAlt(i+1));
        
        idxMin = find(res{1} <= minZ,1,'last');
        idxMax = find(maxZ <= res{1},1,'first');
        
        idx = idxMin:idxMax-1;
        frac = ones(size(idx)); % How much to put in each bin
        
        try
          frac(1) = (res{1}(idxMin+1)-minZ)/(res{1}(idxMin+1)-res{1}(idxMin));
          frac(end) = (maxZ-res{1}(idxMax-1))/(res{1}(idxMax)-res{1}(idxMax-1));
        catch e
          disp(['If you see this text, then the min and max of the ' ...
                'histogram are too small.'])
          getReport(e)
          keyboard
        end
        
        frac = frac/sum(frac);
        res{2}(idx) = res{2}(idx) + frac*totalMass;
      end
      
    catch e
      getReport(e)
      keyboard
    end
  end
end
