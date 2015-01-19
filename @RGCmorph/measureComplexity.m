function res = measureComplexity(obj,branch,res)

  bo = branch.branchOrder + 1; % Since matlab index starts at 0
  
  if(numel(res) < bo)
    res(bo) = 1;
  else
    res(bo) = res(bo) + 1;
  end
  
end
