function res = allCoordsWeight(obj,branch,parent,res)
  
  if(~isempty(parent))
    
    % To get full branch extent we need to include end point of parent
    fullBranch = [parent.coords(end,:); branch.coords];
    
  else
    % No parent, deal with it
    fullBranch = branch.coords;
    
  end
  
  if(size(fullBranch,1) <= 1)
    % Zero or one point, branch is empty dont update res
    return
  end
  
  % Centre points of segments
  coords = (fullBranch(1:end-1,:) + fullBranch(2:end,:))/2;
  len = sum(diff(fullBranch).^2,2);
  
  res = [res; coords, len];
  
end
  
