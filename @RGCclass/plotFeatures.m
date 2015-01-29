function plotFeatures(obj,featureList,interactiveFlag)

  pMarked = [];
  pText = [];
  xSave = {};
  ySave = {};
  sp = [];
  
  if(~exist('interactiveFlag') | isempty(interactiveFlag))
    interactiveFlag = true;
  end
  
  unknownColour = [1 1 1]*0.3;
  
  if(~exist('featureList'))
    featureList = obj.allFeatureNames;
  end
    
  if(~iscell(featureList))
    featureList = {featureList};
  end
  
  nFeat = numel(featureList);

  fig = figure();

  if(interactiveFlag)
    set(fig,'windowbuttonmotionfcn',@mouseHandle);
  end
    
  rg = RGCgui(obj);
  typeCol = rg.classColours;
  
  % typeCol = [228,26,28 ;...
  %            55,126,184;...
  %            77,175,74;...
  %            152,78,163;...
  %            255,127,0] / 255;  
  
  
  
  className = {};
  for j = 1:numel(obj.RGC)
    if(obj.RGC(j).typeID == -1)
      % Unknown, skip
    else
      className{obj.RGC(j).typeID} = obj.RGC(j).typeName;
    end
  end
  
  
  for i = 1:nFeat
    if(numel(nFeat) > 1)
      sp(i) = subplot(ceil(nFeat/2),2,i);
    end
    
    try
      xAll = obj.getVariable(featureList{i})*obj.unitDisplayScaling(featureList{i}); 
      yAll = zeros(size(xAll));
    catch e
      getReport(e)
      keyboard
    end
      
    for j = 1:numel(obj.RGC);
      x = xAll(j);
      y = obj.RGC(j).typeID + 0.2*(1-2*rand(1)); % Jitter position
                                               % for visibility
      yAll(j) = y;
      
      if(obj.RGC(j).typeID > 0)
        col = typeCol(obj.RGC(j).typeID,:);
      else
        % Make unknown grey
        col = unknownColour;
      end
      if(strcmpi(obj.RGC(j).xmlFile(end-2:end),'xml'))
        plot(x,y,'.','color',col,'markersize',18)
      else
        plot(x,y,'x','color',col,'markersize',18);
      end
      hold on
    end
    
    xSave{i} = xAll;
    ySave{i} = yAll;
    
    unitDisp = obj.unitDisplay(featureList{i});
    if(~isempty(unitDisp))
      unitDisp = sprintf('(%s)',unitDisp);
    end
    
    xLab = sprintf('%s %s', obj.featureNameDisplay(featureList{i}), unitDisp);
    xlabel(xLab,'fontsize',18);
    ylabel('Class','fontsize',24)
    set(gca,'fontsize',18)
    
    set(gca,'ytick',1:numel(className))
    set(gca,'yticklabel',className)
    
    a = axis;
    a(3) = min(obj.RGCtypeID)-0.5;
    a(4) = max(obj.RGCtypeID)+0.5;
    axis(a);
    box off
  end

  if(numel(featureList) > 1)
    fName = sprintf('FIGS/plotFeatures-%d.pdf',numel(featureList));
  else
    fName = sprintf('FIGS/plotFeatures-%s.pdf',featureList{1});
  end
    
  % saveas(gcf,fName,'pdf')
  fName = strrep(fName,'.pdf','.eps');
  printA4(fName)
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function mouseHandle(source, event)

    found = false;
    
    for k = 1:nFeat
      
      set(fig,'currentaxes',sp(k));
      xy = get(sp(k),'currentpoint');

      x = xy(1,1);
      y = xy(1,2);
    
      a = axis();
    
      % Are we inside that plot?
      if(a(1) <= x & x <= a(2) ...
         & a(3) <= y & y <= a(4))

        % Yes, find the closest point
        found = true;
    
        % We need to treat x and y distance on screen accurately
        % Rescale data distance based on plot axis and plot dimensions
        pos = get(sp(k),'position');
        d2 = ((xSave{k}-x)/(a(2)-a(1))*pos(3)).^2 ...
             + ((ySave{k}-y)./(a(4)-a(3))*pos(4)).^2;
        
        [~,minIdx] = min(d2);
       
        % fprintf('Plot: %d Dist: %f\n', k, sqrt(d2(minIdx)))
        
        if(~isempty(pText))
          delete(pText);
        end
        
        pText = text(xSave{k}(minIdx),ySave{k}(minIdx), ...
                     strrep(obj.RGC(minIdx).xmlFile,'.xml',''));
        
        % Abort for-loop
        break;
      end
        
    end
      
    if(found)
      if(~isempty(pMarked))
        delete(pMarked);
      end

      for k = 1:nFeat
        set(fig,'currentaxes',sp(k));
        pMarked(k) = plot(xSave{k}(minIdx),ySave{k}(minIdx),'ko');
      end
        
    end
    
  end
  
end