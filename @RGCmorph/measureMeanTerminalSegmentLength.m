function res = measureMeanTerminalSegmentLength(obj,branch,res)
    
  if(isempty(res))
    res = [0 0 0];
    % First value is mean, second is total count, third is number
    % of segments
  end
    
  % Only count terminal segments
  if(isempty(branch.branches))
    x = branch.coords(:,1);
    y = branch.coords(:,2);
    z = branch.coords(:,3);    

    len = sum(sqrt(diff(x).^2 + diff(y).^2 + diff(z).^2));
    
    res(2) = res(2) + len; % Total len
    res(3) = res(3) + 1;   % Counter
    res(1) = res(2) / res(3); % Mean
  end
    
end
  
