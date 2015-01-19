% !!! OBSOLETE, delete...

function res = measureZdistrib(obj,branch,res)

    if(isempty(res))
      res = zeros(size(Zedges));
    end
      
    x = branch.coords(:,1);
    y = branch.coords(:,2);
    z = branch.coords(:,3); % - results.somaZ; % !! Centre soma at 0    
    d = branch.diameter;

    for i = 1:numel(x)-1
     try 
      % Calculate the total mass
      len = sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2 + (z(i)-z(i+1))^2);
      totalMass = len * (d(i)+d(i+1))/2;
      Zlen = abs(z(i)-z(i+1));
      
      if(Zlen == 0)
        % No Z-extent, put all in same bin
        idx = find(Zedges(1:end-1) <= z(i) & z(i) < Zedges(2:end));
        res(idx) = res(idx) + totalMass;

        try
          assert(numel(idx) == 1) % Just a double check
        catch e
          getReport(e)
          keyboard
        end
      else
        % Place the total mass in the appropriate bins
        minZ = min(z(i),z(i+1));
        maxZ = max(z(i),z(i+1));
      
        idxMin = find(Zedges <= minZ,1,'last');
        idxMax = find(maxZ <= Zedges,1,'first');
      
        idx = idxMin:idxMax-1;
        frac = ones(size(idx)); % How much to put in each bin

        frac(1) = (Zedges(idxMin+1)-minZ)/(Zedges(idxMin+1)-Zedges(idxMin));
        frac(end) = (maxZ-Zedges(idxMax-1))/(Zedges(idxMax)-Zedges(idxMax-1));
      
        frac = frac/sum(frac);
        res(idx) = res(idx) + frac*totalMass;
      end
      
     catch e
       getReport(e)
       keyboard
     end
    end
    
    % totalMass = sqrt(diff(x).^2 + diff(y).^2 + diff(z).^2).*(d(1:end-1)+d(2:end))/2;
  
  end
