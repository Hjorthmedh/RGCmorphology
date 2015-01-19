% Measure: Total length of dendrites (or axons)
%
% Use: obj.parseDendrite(@obj.measureTotalLength)

function res = measureTotalLength(obj,branch,parent,res)

  if(isempty(res))
    res = 0;
  end

  if(isempty(parent))
    x = branch.coords(:,1);
    y = branch.coords(:,2);
    z = branch.coords(:,3);    
  else
    x = [parent.coords(end,1); branch.coords(:,1)];
    y = [parent.coords(end,2); branch.coords(:,2)];
    z = [parent.coords(end,3); branch.coords(:,3)];    
  end
    
  res = res + sum(sqrt(diff(x).^2 + diff(y).^2 + diff(z).^2));
    
  
end
