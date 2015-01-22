% Save values to the RGC object

function updateRGC(obj)
  
  disp('Updating RGC object')

  obj.rgc.VAChTnormal = obj.planeNormal;
  obj.rgc.VAChTdUpper = obj.VAChTdUpper;
  obj.rgc.VAChTdLower = obj.VAChTdLower;

  % obj.rgc.stratificationDepth = obj.stratificationDepth;
  obj.rgc.stratificationDepthScaled = (obj.stratificationDepth - obj.VAChTdUpper) ...
                                      / (obj.VAChTdLower - obj.VAChTdUpper);  

  obj.rgc.manualOverride = obj.manualOverride;
  
  if(isempty(obj.rgc.stratificationDepthScaled))
    disp('Something is fishy with stratificationDepthScaled')
    beep
    keyboard
  end
  
  obj.rgc.biStratified = obj.biStratified;
  
end