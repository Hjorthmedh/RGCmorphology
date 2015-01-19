function [sa,z] = measureSomaArea(obj)

  if(isempty(obj.somaContours))
    sa = NaN;
    z = NaN;
    return
  end
  
  saAll = zeros(numel(obj.somaContours),1);
    
  for i = 1:numel(obj.somaContours)
  
    % Assume all Z-coords the same
    assert(all(diff(obj.somaContours{i}(:,3)) == 0));
    
    [~,saAll(i)] = convhull(obj.somaContours{i}(:,1),obj.somaContours{i}(:,2));
    
  end
  
  % Smooth with average window 5
  saAll = smooth(saAll);
  
  % We want just the largest cross-section
  [sa,saIdx] = max(saAll);
  
  if(0)
    % This takes the largest cross section as the centre
    z = mean(obj.somaContours{saIdx}(:,3));
  else
    % Alternative way of doing it, using the centre contour
    idx = ceil(numel(obj.somaContours)/2);
    z = mean(obj.somaContours{idx}(:,3));
  end
  
end
