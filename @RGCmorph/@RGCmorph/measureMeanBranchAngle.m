function res = measureMeanBranchAngle(obj,branch,res)
    
  if(isempty(res))
    res = [0 0 0];
  end
    
  if(numel(branch.branches) >= 2)
    % Only do this if there are two (or more) child branches
    % We are ignoring the third child if it exists  
    
    bp = branch.coords(end,:);

    %ep1 = branch.branches(1).coords(end,:);
    %ep2 = branch.branches(2).coords(end,:);

    ep1 = branch.branches(1).coords(1,:);
    ep2 = branch.branches(2).coords(1,:);

    ctr = 1;
    while(all(ep1 == bp) & size(branch.branches(1).coords,1) > ctr)
      ctr = ctr + 1;
      ep1 = branch.branches(1).coords(ctr,:);
      fprintf('branchAngle: Using second point on branch A (%d)\n', ctr)
    end

    if(ctr > 5)
      disp('This is weird...')
      keyboard
    end
    
    ctr = 1;
    while(all(ep2 == bp) & size(branch.branches(2).coords,1) > ctr)
      ctr = ctr + 1;
      ep2 = branch.branches(2).coords(ctr,:);
      fprintf('branchAngle: Using second point on branch B (%d)\n', ctr)    
    end
    
    if(ctr > 5)
      disp('This is weird...')
      keyboard
    end
     
    
    
    a = ep1 - bp;
    b = ep2 - bp;
    
    v = acos(sum(a .* b)/(norm(a)*norm(b)));
    
    if(imag(v))
      if(imag(v) < 1e-6)
        v = real(v);
      else
        disp('Imaginary angle!!')
        keyboard
      end
    end
      
    % fprintf('%f,',v)
    
    if(~isnan(v))
      res(2) = res(2) + v;
      res(3) = res(3) + 1;
      res(1) = res(2) / res(3);
    else
      disp('Branch angle NaN, ignoring.')
    end
    
    
    if(isnan(v))
      if(size(branch.branches(1).coords,1) > 1 ...
         & size(branch.branches(2).coords,1) > 1)
        disp('Branch angle is NaN')
        keyboard
      end
    end
    
  end

end
  
