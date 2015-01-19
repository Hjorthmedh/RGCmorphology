function sd = measureSomaDiameter(obj)

  if(isempty(obj.somaContours))
    sd = NaN;
    return
  end  
  
  sd = zeros(numel(obj.somaContours),1);

  for i = 1:numel(obj.somaContours)
    % Assume all Z-coords the same
    assert(all(diff(obj.somaContours{i}(:,3)) == 0));
    
    x = obj.somaContours{i}(:,1);
    y = obj.somaContours{i}(:,2);
    
    X = kron(x,transpose(ones(size(x))));
    Y = kron(y,transpose(ones(size(y))));
    
    d = sqrt(X-transpose(X)).^2 + (Y-transpose(Y)).^2;
    
    sd = max(d(:));
    
  end
  
  sd = max(sd);
  
end
  
  
