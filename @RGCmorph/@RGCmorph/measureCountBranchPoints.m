function res = measureCountBranchPoints(obj,branch,res)
  
  if(~isempty(branch.branches))
    % If the branch has children, count it as a branch point
    
    if(isempty(res))
      res = 1;
    else
      res = res + 1;
    end
    
  end
  
end
