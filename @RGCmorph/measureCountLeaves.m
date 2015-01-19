function res = measureCountLeaves(obj,branch,res)
  
  if(isempty(branch.branches))
    % If the branch has no children, count it as a leaf
    
    if(isempty(res))
      res = 1;
    else
      res = res + 1;
    end
    
  end
  
end
