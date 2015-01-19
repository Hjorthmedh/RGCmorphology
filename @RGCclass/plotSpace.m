function plotSpace(obj, plotList, modalClassID,showLegendFlag,reuseFigureFlag)

  if(exist('modalClassID') & ~isempty(modalClassID))
    markClassification = true;
  else
    markClassification = false;
  end
    
  if(~exist('showLegendFlag'))
    showLegendFlag = true;
  end
  
  if(~exist('reuseFigureFlag'))
    reuseFigureFlag = false;
  end
  
  showTitle = false;
  
  fontSize = 9;
  markWrongSymbol = 'v'; % 'o'
  
  RG = RGCgui(obj);
  
  uid = unique(obj.RGCtypeID);
  nid = numel(uid);

  if(strcmpi(plotList,'pca'))
    % Lets plot PCA space
    
    [pc,score,latent] = pca(obj.featureMat);
    x = score(:,1);
    y = score(:,2);
    
    xScale = 1;
    yScale = 1;
    z = [];
    
    fprintf('PCA variance, comp 1: %f (%.2f %%), comp 2: %f (%.2f %%)\n', ...
            latent(1),latent(1)/sum(latent)*100,latent(2),latent(2)/sum(latent)*100)
    latent
    
  else
  
    if(isnumeric(plotList))
      % We already got the indexes, great
      plotListIdx = plotList;
    else
      % We need to find the 
    
      for i = 1:numel(plotList)
        plotListIdx(i) = find(ismember(obj.allFeatureNames,plotList{i}));
      end
    end

    
    % Nu gick vi över ån för vatten
    x = obj.getVariable(obj.allFeatureNames{plotListIdx(1)});
    y = obj.getVariable(obj.allFeatureNames{plotListIdx(2)});

    xScale = obj.unitDisplayScaling(obj.allFeatureNames{plotListIdx(1)});
    yScale = obj.unitDisplayScaling(obj.allFeatureNames{plotListIdx(2)});  
  
    if(numel(plotList) >= 3)
      z = obj.getVariable(obj.allFeatureNames{plotListIdx(3)});  
      zScale = obj.unitDisplayScaling(obj.allFeatureNames{plotListIdx(3)});  
    else
      z = [];
      zScale = [];
    end
  end
    
  if(~reuseFigureFlag)
    figure
  end
  
  for i = 1:nid
    id = uid(i);
    idx = find(obj.RGCtypeID == id); 

    if(~isempty(z))
      p(i) = plot3(x(idx)*xScale,y(idx)*yScale,z(idx)*zScale, ...
                    '.','color',RG.classColours(id,:), ...
                    'markersize',7);
    else
      p(i) = plot(x(idx)*xScale,y(idx)*yScale, ...
                   '.','color',RG.classColours(id,:), ...
                   'markersize',7);      
    end
    
    pLeg{i} = obj.RGCtypeName{idx(1)};
    
    hold on
  end
  
  if(markClassification)
    % Mark the cells missclassified
  
    badIdx = find(obj.RGCtypeID ~= modalClassID);
    
    for i = 1:numel(badIdx)
      idx = badIdx(i);
      
      if(~isempty(z))
        plot3(x(idx)*xScale,y(idx)*yScale,z(idx)*zScale, ...
                    markWrongSymbol,'color',RG.classColours(modalClassID(idx),:), ...
                    'markersize',4,'linewidth',3);
      else
        plot(x(idx)*xScale,y(idx)*yScale, ...
             markWrongSymbol,'color',RG.classColours(modalClassID(idx),:), ...
             'markersize',4);      
      end
    end

    nCorr = nnz(obj.RGCtypeID == modalClassID);
    str = sprintf('%d/%d correctly classified (%.1f %%)', ...
                  nCorr, numel(obj.RGC), nCorr/numel(obj.RGC)*100);
    if(showTitle)
      title(str);
    end
  end

  if(strcmpi(plotList,'pca'))
    % PCA space
    xlabel('Principal Component #1','fontsize',fontSize)
    ylabel('Principal Component #2','fontsize',fontSize)
    
    fName = sprintf('FIGS/Summary-plot-PCA-space-%s.pdf',obj.dataSetName);
    
  else
    xUnit = obj.unitDisplay(obj.allFeatureNames{plotListIdx(1)});
    yUnit = obj.unitDisplay(obj.allFeatureNames{plotListIdx(2)});

    if(~isempty(xUnit))
      xUnit = sprintf(' (%s)', xUnit);
    end

    if(~isempty(yUnit))
      yUnit = sprintf(' (%s)', yUnit);
    end
  
    xLab = strcat(obj.featureNameDisplay(obj.allFeatureNames{plotListIdx(1)}), ...
                  xUnit);
    yLab = strcat(obj.featureNameDisplay(obj.allFeatureNames{plotListIdx(2)}), ...
                  yUnit);

    xlabel(xLab,'fontsize',fontSize)
    ylabel(yLab,'fontsize',fontSize)  

    if(~isempty(z))
      zUnit = obj.unitDisplay(obj.allFeatureNames{plotListIdx(3)});  
      if(~isempty(zUnit))
        zUnit = sprintf(' (%s)', zUnit);
      end
    
      zLab = strcat(obj.featureNameDisplay(obj.allFeatureNames{plotListIdx(3)}), ...
                    zUnit)
      zlabel(zLab,'fontsize',fontSize)
    end
  
    if(~isempty(z))
      fName = sprintf('FIGS/Summary-plot-%s-%s-%s.pdf', ...
                      obj.featureNameDisplay(obj.allFeatureNames{plotListIdx(1)}), ...
                      obj.featureNameDisplay(obj.allFeatureNames{plotListIdx(2)}), ...
                      obj.featureNameDisplay(obj.allFeatureNames{plotListIdx(3)}));
    else
      fName = sprintf('FIGS/Summary-plot-%s-%s.pdf', ...
                      obj.featureNameDisplay(obj.allFeatureNames{plotListIdx(1)}), ...
                      obj.featureNameDisplay(obj.allFeatureNames{plotListIdx(2)}));
    end
    
    fName = strrep(fName,' ','-');

  end
  
  set(gca,'fontsize',fontSize)

  if(showLegendFlag)
    legend(p,pLeg)
  end
  
  
  box off
  % axis tight
  
  saveas(gcf,fName,'pdf')
  fNameEPS = strrep(fName,'.pdf','.eps');
  printA4(fNameEPS)
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  

  
end