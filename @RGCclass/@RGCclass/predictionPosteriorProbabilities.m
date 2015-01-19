function [classID, postP] = predictionPosteriorProbabilities(obj,nRep,kFold,plotFlag)

  % Currently only doing NaiveBayes, but can easilly be expanded to
  % other methods (predict returns posterior probabilities, but not
  % for NB).
  assert(strcmpi(obj.classifierMethod,'NaiveBayes'))
  
  
  if(~exist('nRep') | isempty(nRep))
    nRep = 100;
  end
  
  if(~exist('kFold') | isempty(kFold))
    kFold = 5;
  end
  
  if(~exist('plotFlag') | plotFlag)
    plotFlag = true;
  end
  
  postP = NaN*zeros(numel(obj.RGC),nRep);
  correctFlag = nan*ones(size(postP));
  
  for iRep = 1:nRep
    
    idx = ceil(kFold*rand(numel(obj.RGC),1));
    
    for iFold = 1:kFold
      
      trainIdx = find(idx ~= iFold);
      testIdx = find(idx == iFold);
      
      obj.train(trainIdx);

      try
        classID(testIdx,iRep) = obj.classify(testIdx);
        
        [post,cpre] = obj.classifier.posterior(obj.featureMat(testIdx,:));
        for i = 1:numel(testIdx)
          postP(testIdx(i),iRep) = post(i,cpre(i));
          assert(cpre(i) == classID(testIdx(i),iRep));
        end
      catch e
        getReport(e)
        keyboard
      end
    end
    
  end

  % Sort them so they are in class order
  [sortID,sortIdx] = sort(obj.RGCtypeID);
  
  if(plotFlag)
    
    figure
    
    RG = RGCgui(obj);

    if(nRep > 1)
      for iCell = 1:numel(obj.RGC)
        idx = sortIdx(iCell);
        
        pVal = postP(idx,:);
      
        plot(iCell*[1 1],[min(pVal) max(pVal)],'-','color',0.9*[1 1 1])
        hold on
      end
    end
    
    for iRep = 1:nRep
      for iCell = 1:numel(obj.RGC)
        idx = sortIdx(iCell);

        if(classID(idx,iRep) == obj.RGCtypeID(idx))
          marker = 'o';
          correctFlag(idx,iRep) = 1;
        else
          marker = 'v';
          correctFlag(idx,iRep) = 0;
        end
        
        p = plot(iCell,postP(idx,iRep), ...
                 marker, 'color',RG.classColours(classID(idx,iRep),:));
        hold on
      end
    end

    
    
    
    % Plot average posterior probability
    if(0)
      meanPostP = mean(postP,2);
      
      for i = 1:numel(obj.RGCuniqueIDs)
        idx = find(sortID == obj.RGCuniqueIDs(i));
        
        plot([min(idx) max(idx)],mean(meanPostP(idx))*[1 1],...
             '-','color',RG.classColours(obj.RGCuniqueIDs(i),:), ...
             'linewidth',2)
        
      end
    end
    
    a = axis;
    a(1) = 0;
    a(2) = numel(obj.RGC) + 1;
    axis(a);
    
    % Plot separators
    for i = 1:numel(sortID)-1
      if(find(sortID(i) ~= sortID(i+1)))
        x = i + 0.5;
        plot(x*[1 1], a(3:4),'k-')
      end
    end  
    
    for i = 1:numel(obj.RGCuniqueIDs)
      
      idx = find(obj.RGCuniqueIDs(i) == sortID);
      textPosX = mean(idx);
      
      txt = text(textPosX, 1.03, obj.RGCuniqueNames{i}, ...
                 'fontsize',20,'color',RG.classColours(i,:));
      set(txt,'HorizontalAlignment','center')

    end
    
    % grid on
    % box off
    
    % keyboard
    
    if(0)
      % !! Fixme, make text vertical
      set(gca,'xtick',1:numel(obj.RGC));
      
      xLab = {};
      for i = 1:numel(obj.RGC)
        xLab{i} = strrep(obj.RGC(i).xmlFile,'.xml','');
      end
      set(gca,'xticklabel',xLab);
    else
      set(gca,'xtick',[])
    end
    
    ylabel('Confidence','fontsize',20)
    set(gca, 'XAxisLocation', 'top')

    saveas(gcf,'FIGS/Confidence-in-classification.pdf','pdf')
    
  end

  %% List the missclassified cells with confidence over 80%
  
  Pthresh = 0.95;
  errorCount = sum(~correctFlag,2);
  sureButWrongCount = sum(~correctFlag & postP > Pthresh,2);
  
  errorIdx = find(errorCount);
  wasSureButWrongIdx = find(sureButWrongCount);
  
  disp('\nAll cells that were incorrectly classified at least ones')
  for i = 1:numel(errorIdx)

    idx = errorIdx(i);
    fprintf('%s Error: %d\n', strrep(obj.RGC(idx).xmlFile,'.xml',''), errorCount(idx))
    
  end
  
  fprintf('\nCells that were certain > %.1f %%, but still wrong\n', 100*Pthresh)
  
  for i = 1:numel(wasSureButWrongIdx)
    idx = wasSureButWrongIdx(i);
    
    fprintf('%s, %d/%d errors while %.1f %% confident\n', ...
            strrep(obj.RGC(idx).xmlFile,'.xml',''), ...
            sureButWrongCount(idx), nRep, Pthresh*100)
  end
  
end



