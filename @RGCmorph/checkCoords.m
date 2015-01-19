% This function checks that the coordinates from the XML tracing
% and the LSM image stack are within the same range

function okFlag = checkCoords(obj)

  maxCoordXML = obj.parseDendrites(@maxCoord);
  minCoordXML = obj.parseDendrites(@minCoord);
  
  maxCoordLSM = max(obj.zCoordsXML);
  minCoordLSM = min(obj.zCoordsXML);
  
  if(maxCoordXML(3) > maxCoordLSM | minCoordXML(3) < minCoordLSM)
    fprintf('!!! %s\n', obj.xmlFile)
    fprintf('!!! XML Z coords out of range of LSM image: XML (%.2f,%.2f), LSM (%.2f,%.2f)\n',...
            minCoordXML(3), maxCoordXML(3), minCoordLSM, maxCoordLSM)

    okFlag = false;
  else
    okFlag = true;
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  function res = maxCoord(branch,res)

    if(isempty(res))
      res = max(branch.coords);
    else
      res = max(res,max(branch.coords,[],1));
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function res = minCoord(branch,res)

    if(isempty(res))
      res = min(branch.coords);
    else
      res = min(res,min(branch.coords,[],1));
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end