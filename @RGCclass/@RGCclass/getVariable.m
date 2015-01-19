function varVector = getVariable(obj,varName)

  varVector = zeros(numel(obj.RGC),1);
  
  for i = 1:numel(obj.RGC)
    try
      varVector(i) = eval(sprintf('obj.RGC(i).stats.%s;',varName));
    catch e
      getReport(e)
      keyboard
    end
  end
  
end
