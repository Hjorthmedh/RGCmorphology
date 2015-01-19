
function results = analyse(obj,loadVAChTflag)
  
  showFigures = true;
  
  fprintf('Analyse called: %s\n', obj.xmlFile)
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if(~exist('loadVAChTflag'))
    loadVAChTflag = false;
  end
  
  % This is only done if the cell has VAChT info
  if(obj.hasVAChT)
  
    % Do not show GUI for the neurons that have already been manually
    % inspected and saved.
    skipGUI = true;
  
    % Detect the VAChT bands
  
    v = VAChT(obj,loadVAChTflag, skipGUI);
  
    if(~skipGUI)
      disp('Waiting for user to finish...')
    end
  
    if(~isempty(v.fig))
      uiwait(v.fig);
      disp('VAChT done, resuming')
    end
    
  end
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  [obj.typeID, obj.typeName] = obj.RGCtype();
    
  results = calculateMeasures(obj,showFigures);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end