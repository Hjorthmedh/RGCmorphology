function res = measureSegmentTortuosity(obj,branch,res)
    
  if(isempty(res))
    res = [0 0 0];
    % First value mean tortuosity ratio, 
    % 2nd value all tortuosity ratios summed,
    % 3rd value num items summed
  end
    
  x = branch.coords(:,1);
  y = branch.coords(:,2);
  z = branch.coords(:,3);    

  if(numel(x) < 2)
    % Need at least two points
    return
  end
    
  len = sum(sqrt(diff(x).^2 + diff(y).^2 + diff(z).^2));
  sLen = sqrt((x(end)-x(1)).^2 ...
              + (y(end)-y(1)).^2 ...
              + (z(end)-z(1)).^2);
  
  r = len / sLen;
  
  if(sLen > 0)
    % If there are any zero lengths, lets ignore them
    
    res(2) = res(2) + r;
    res(3) = res(3) + 1;
    res(1) = res(2) / res(3);

  end    

  if(len < 0 || sLen < 0)
    disp('You have negative lengths, check your maths! My maths!')
    keyboard 
  end

    
end
  
