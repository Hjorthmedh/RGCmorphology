
function res = measureZlensum(obj,branch,res)

  x = branch.coords(:,1);
  y = branch.coords(:,2);
  z = branch.coords(:,3) - results.somaZ; % Centre soma around 0
  d = branch.diameter;

  if(numel(x) == 1)
    % Zero extent branch, ignore
    return
  end
    
  len = sqrt(diff(x).^2 + diff(y).^2 + diff(z).^2);
  w = len.*(d(1:end-1)+d(2:end))/2; % How to weight each compartment
  zCent = (z(1:end-1)+z(2:end))/2;    
    
  if(isempty(res))
    res = [sum(zCent.*w), sum(w)];
  else
    res = res + [sum(zCent.*w), sum(w)];      
  end
    
end
