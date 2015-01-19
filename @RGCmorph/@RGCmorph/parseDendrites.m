% This function applies the func to all branches
%
% func takes two arguments, branch and old results, and returns new results


function result = parseDendrites(obj, func, passParentFlag)

  % Some functions need to know the endpoint of the parent, so if
  % passParentFlag is set, they will get their parent passed also
    
  if(~exist('passParentFlag'))
    passParentFlag = false;
  end
  
  result = [];
  
  if(passParentFlag)

    for j = 1:numel(obj.dendrite)
      parseBranchParent(obj.dendrite(j), []); % Soma does not count as parent
    end
    
  else
  
    for j = 1:numel(obj.dendrite)
      parseBranch(obj.dendrite(j));
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function parseBranch(branch)

    result = func(branch, result);
  
    for i = 1:numel(branch.branches)
      parseBranch(branch.branches(i));
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function parseBranchParent(branch,parent)
    
    result = func(branch,parent,result);
    
    for i=1:numel(branch.branches)
      parseBranchParent(branch.branches(i),branch);
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end