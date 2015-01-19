% Measure: Number of segments in dendritic tree (or axon)
% Use: numSegments = obj.parseDendrites(@obj.measureNumSegments)

function res = measureNumSegments(obj,branch,res)
  if(isempty(res))
    res = 1;
  else
    res = res + 1;
  end
end
