function [classID, postP] = predictionPosteriorProbabilitiesLeaveOneOut(obj,plotFlag)

  % Currently only doing NaiveBayes, but can easilly be expanded to
  % other methods (predict returns posterior probabilities, but not
  % for NB).
  assert(strcmpi(obj.classifierMethod,'NaiveBayes'))
    
  if(~exist('plotFlag') | plotFlag)
    plotFlag = true;
  end
  
  postP = NaN*zeros(numel(obj.RGC),1);
  correctFlag = nan*ones(size(postP));
  
  for i = 1:numel(obj.RGC)
    
    trainIdx = setdiff(1:numel(obj.RGC),i);
    testIdx = i;
    
    obj.train(trainIdx);
    
    classID(testIdx) = obj.classify(testIdx);
    [post,cpre] = obj.classifier.posterior(obj.featureMat(testIdx,:));
    
    try
      postP(testIdx) = post(find(cpre == obj.classifier.ClassLevels));
      assert(cpre == classID(testIdx));
      % keyboard
    catch e
      getReport(e)
      keyboard
    end
      
  end

  % Sort them so they are in class order
  [sortID,sortIdx] = sort(obj.RGCtypeID);
  
  % Since IDs are not consequtive we need to make sure the offset
  % is ok
  uniqueIDs = unique(obj.RGCtypeID);
  
  if(plotFlag)
    
    figure
    
    RG = RGCgui(obj);

    for iCell = 1:numel(obj.RGC)
      idx = sortIdx(iCell);

      if(classID(idx) == obj.RGCtypeID(idx))
        marker = '.';
        lineWidth = 1;
        markerSize = 9;
        correctFlag(idx) = 1;
      else
        marker = 'v';
        lineWidth = 1;
        markerSize = 5;
        correctFlag(idx) = 0;
      end
        
      % By adding spacing we will separate the classes by an empty "column"
      spacing = 3*find(obj.RGCtypeID(idx) == uniqueIDs)-3;
      p = plot(iCell + spacing,postP(idx), ...
               marker, 'color',RG.classColours(classID(idx),:), ...
               'linewidth', lineWidth, 'markersize',markerSize);
      hold on
    end

    a = axis;
    a(1) = 0;
    % a(2) = numel(obj.RGC) + 1;
    a(2) = iCell + spacing;
    a(3) = 0;
    axis(a);
    
    Pcor = obj.getRandomChance();
    plot(a(1:2),Pcor*[1 1],'b--','linewidth',1)
    
    % Plot separators
    sepCtr = 1;
    for i = 1:numel(sortID)-1
      if(find(sortID(i) ~= sortID(i+1)))
        x = i + 1 + sepCtr;
        plot(x*[1 1], a(3:4),'k-')
        sepCtr = sepCtr + 3;
      end
    end  
    
    % Plot titles
    
    for i = 1:numel(obj.RGCuniqueIDs)
      
      idx = find(obj.RGCuniqueIDs(i) == sortID);
      textPosX = mean(idx) + (i-1)*3;
      
      txt = text(textPosX, 1.03, obj.RGCuniqueNames{i}, ...
                 'fontsize',10,'color',RG.classColours(obj.RGCuniqueIDs(i),:));
      set(txt,'HorizontalAlignment','center')

    end
    
    grid on
    % box off
    
    % keyboard
    
    set(gca,'xtick',[])
    set(gca,'ygrid','on')    
    set(gca,'ytick',0:0.2:1)
    set(gca,'yticklabel',0:0.2:1)
    set(gca,'yminortick','off')
    
    ylabel('Confidence','fontsize',12)
    set(gca, 'XAxisLocation', 'top')

    set(gcf,'paperunits','centimeters')
    set(gcf,'units','centimeters')
    set(gcf,'papersize',[8 8])
    set(gcf,'paperposition',[0 0 8 8])
    
    
    % saveas(gcf,'FIGS/Confidence-in-classification-leave-one-out.pdf','pdf')
    printA4(sprintf('FIGS/%s-Confidence-in-classification-leave-one-out.eps',obj.dataSetName))

    
  end

  %% List the missclassified cells with confidence over 80%
  
  Pthresh = 0.8;

  errorIdx = find(~correctFlag);
  wasSureButWrongIdx = find(~correctFlag & postP > Pthresh);
  
  disp('\nAll cells that were incorrectly classified')
  for i = 1:numel(errorIdx)

    idx = errorIdx(i);
    fprintf('%s\n', strrep(obj.RGC(idx).xmlFile,'.xml',''))
    
  end
  
  fprintf('\nCells that were certain > %.1f %%, but still wrong\n', 100*Pthresh)
  
  for i = 1:numel(wasSureButWrongIdx)
    idx = wasSureButWrongIdx(i);
    
    fprintf('%s, error while %.0f %% confident\n', ...
            strrep(obj.RGC(idx).xmlFile,'.xml',''), ...
            postP(idx)*100)
  end
  
  fprintf('\nError count: %d/%d\n', sum(~correctFlag), numel(obj.RGC))
  
end



