function tdf = measureTotalDendriticField(obj)
  
  % First we need to gather up all the coordinates for all the
  % dendritic branches
  
  xyz = obj.parseDendrites(@obj.allCoords);
    
  % Here we are ignoring the Z-coordinate
  x = xyz(:,1);
  y = xyz(:,2);
    
  [~,tdf] = convhull(x,y);
    
end
