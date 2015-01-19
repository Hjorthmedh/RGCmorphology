function assymetryIndex = measureBranchAssymetry(obj)

  
  ratio = [];
  
  for j = 1:numel(obj.dendrite)
    countSubBranches(obj.dendrite(j));
  end
    
  assymetryIndex = mean(ratio);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % This function updates the ratio variable
  function numLeaves = countSubBranches(branch)
    
    numLeaves = 0;
    
    numBranchLeaves = [];
    
    try
      for i = 1:numel(branch.branches)
        numBranchLeaves(end+1) = countSubBranches(branch.branches(i));
      end
    catch e
      getReport(e)
      keyboard
    end
      
    numLeaves = sum(numBranchLeaves);
    
    if(numLeaves == 0)
      % This was a leaf itself, add one
      numLeaves = 1;
    else
      % I prefer the max/sum instead of min/sum because some branch
      % points have three children
      ratio(end+1) = max(numBranchLeaves)/sum(numBranchLeaves);
      
    end
    
  end

end