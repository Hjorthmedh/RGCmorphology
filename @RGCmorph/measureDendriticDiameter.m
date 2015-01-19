function dd = measureDendriticDiameter(obj)

  % First we need to gather up all the coordinates for all the
  % dendritic branches
  
  xyz = obj.parseDendrites(@obj.allCoords);
    
  % Here we are ignoring the Z-coordinate
  x = xyz(:,1);
  y = xyz(:,2);
    
  [~,tdf] = convhull(x,y);

  % Find the largest diameter
  d2max = 0;

  for i = 1:numel(x)
    d2 = (x(i)-x).^2 + (y(i)-y).^2;
    d2max = max(d2max,max(d2(:)));
  end

  if(0)
    % Old code, kept here for debugging. It uses ALOT of memory for
    % some dendritic arbours, caused my laptop to crash!
    
    X1 = kron(x,ones(1,numel(x)));
    Y1 = kron(y,ones(1,numel(y)));
  
    X2 = kron(ones(numel(x),1),transpose(x));
    Y2 = kron(ones(numel(y),1),transpose(y));

    d2 = (X1-X2).^2 + (Y1-Y2).^2;
    d2maxA = max(d2(:));
  
    try
      assert(d2maxA == d2max)
    catch e
      getReport(e)
      keyboard
    end
  end
  
  
  % We do the sqrt after, that way we have to do it ones as opposed
  % to N times.
  dd = sqrt(d2max);
  
end