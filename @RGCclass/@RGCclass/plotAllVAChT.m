% This plots all VAChT bands so we can compare them

function plotAllVAChT(obj)

  typeCol = [228,26,28 ;...
             55,126,184;...
             77,175,74;...
             152,78,163;...
             255,127,0] / 255; 

  zCoords = {};
  VAChTmean = {};
  VAChTsample = {};
  
  zSoma = zeros(numel(obj.RGC),1);

  className = {};
  for j = 1:numel(obj.RGC)
    className{obj.RGC(j).typeID} = obj.RGC(j).typeName;
  end  
  
  v = VAChT();
  
  for i = 1:numel(obj.RGC)
    rgc = obj.RGC(i);
    
    if(isempty(rgc.lsm))
      rgc.readLSM(rgc.lsmFile,rgc.lsmDir);
      clearLSM = true;
    else
      clearLSM = false;
    end
      
    zCoords{i} = rgc.zCoordsXML;
    VAChTmean{i} = zeros(size(rgc.zCoordsXML));
    VAChTsample{i} = zeros(size(rgc.zCoordsXML));
    
    for j = 1:size(rgc.lsm.image,4)
      img = double(rgc.lsm.image(:,:,v.VAChTchannel,j));
      VAChTmean{i}(j) = mean(img(:));
      
      d = 10; % square, side 10 micrometers
      
      xSoma = round((rgc.xSoma-d/2)/rgc.xScaleXML):round((rgc.xSoma+d/2)/rgc.xScaleXML);
      ySoma = round((-rgc.ySoma-d/2)/rgc.yScaleXML):round((-rgc.ySoma+d/2)/rgc.yScaleXML);
      
      img = double(rgc.lsm.image(ySoma,xSoma,v.VAChTchannel,j));
      VAChTsample{i}(j) = mean(img(:));
    end
    
    zVals = [];
    for j = 1:numel(rgc.somaContours)
      zVals = [zVals; rgc.somaContours{j}(:,3)];
    end
    
    zSoma(i) = mean(zVals);
    
    if(clearLSM)
      rgc.lsm = [];
    end
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Plot the profiles for each cell type
  
  uID = unique(obj.RGCtypeID);
  
  figure
  
  for i = 1:numel(uID)
    idx = find(uID(i) == obj.RGCtypeID);
    
    subplot(ceil(numel(uID)/2),2,i)
    hold on
    
    for j = 1:numel(idx)
      k = idx(j);
      % plot(VAChTmean{k},zCoords{k}-zSoma(k),'-', ...
      %      'color', typeCol(i,:));
      plot(VAChTmean{k},zCoords{k}-zSoma(k),'-');
      hold all
    end
    
    title(className{i})
    xlabel('VAChT slice')
    ylabel('Depth (soma=0)')
    
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Plot the profiles for each cell type
  
  figure
  
  for i = 1:numel(uID)
    idx = find(uID(i) == obj.RGCtypeID);
    
    subplot(ceil(numel(uID)/2),2,i)
    hold on
    
    for j = 1:numel(idx)
      k = idx(j);
      %plot(VAChTmean{k}/max(VAChTmean{k}),zCoords{k}-zSoma(k),'-', ...
      %     'color', typeCol(i,:));
      plot(VAChTmean{k}/max(VAChTmean{k}),zCoords{k}-zSoma(k),'-');
      hold all
    end
    
    title(className{i})
    xlabel('VAChT slice (normalised)')
    ylabel('Depth (soma=0)')
    
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Plot the profiles for each cell type
  
  figure
  
  for i = 1:numel(uID)
    idx = find(uID(i) == obj.RGCtypeID);
    
    subplot(ceil(numel(uID)/2),2,i)
    hold on
    
    for j = 1:numel(idx)
      k = idx(j);
      % plot(VAChTsample{k}/max(VAChTsample{k}),zCoords{k}-zSoma(k),'-', ...
      %      'color', typeCol(i,:));
      plot(VAChTsample{k}/max(VAChTsample{k}),zCoords{k}-zSoma(k),'-');
      hold all
    end
    
    title(className{i})
    xlabel('VAChT column (normalised)')
    ylabel('Depth (soma=0)')
    
  end

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end