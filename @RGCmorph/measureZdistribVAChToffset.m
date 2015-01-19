% This rotates the coordinate frame according to the VAChT planes,
% and then adds an offset to the Z-coordinate so that the lower VAChT
% band is at Z=0.
  
function res = measureZdistribVAChToffset(obj,branch,res)
 
  if(isempty(res))
    nBins = 1000;
    ZedgesAltOfs = -100:1:100;
    res{1} = ZedgesAltOfs;                 % edges
    res{2} = zeros(1,numel(ZedgesAltOfs)); % binned data
  end
          
  % We do need to centre coordinate system around soma for the
  % z-coordinates to be correct.
    
  x = branch.coords(:,1) - obj.xSoma;
  y = branch.coords(:,2) - obj.ySoma;
  z = branch.coords(:,3);
  d = branch.diameter;
  
  v = obj.VAChTnormal;
    
  zAlt = [x,y,z]*v - obj.VAChTdLower;
    
  % Use normal coords to calculate the length of each segment
    
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

