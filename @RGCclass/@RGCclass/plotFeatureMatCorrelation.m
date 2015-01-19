function plotFeatureMatCorrelation(obj)

  % Assume that rows are data, and columns are features

  nFeatures = size(obj.featureMat,2);
  

  
  profFlag = false;
  
  if(profFlag)
    profile on
  end
  
  R = corrcoef(obj.featureMat);
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Lets make a simple threshold plot first
  
  Rthresh = abs(R) > 0.7;

  % Lets sort them...
  
  [~,idx] = sort(sum(abs(R)),'descend');
  
  figure
  %subplot(2,2,1)
  imagesc(R(idx,idx)), colorbar
  axis equal
  axis tight
  set(gca,'xtick',1:size(R,2))
  set(gca,'xticklabel',idx);
  set(gca,'ytick',1:size(R,1))
  
  labelStr = {};
  for i = 1:numel(obj.featuresUsed)
    labelStr{i} = sprintf('%s %d', obj.featuresUsed{idx(i)},idx(i));
  end
  set(gca,'yticklabel',labelStr)
  
  title('Sorted by sum of absolute corr coeff')
  
  saveas(gcf,'FIGS/featureMat-pairwise-correlation-coloured.pdf','pdf')
  
  
  set(gca,'yticklabel',labelStr);  
  figure
  %subplot(2,2,2)
  imagesc(Rthresh(idx,idx))
  axis equal
  axis tight
  set(gca,'xtick',1:size(R,2))
  set(gca,'xticklabel',idx);  
  set(gca,'ytick',1:size(R,1))
  %set(gca,'yticklabel',idx);
  set(gca,'yticklabel',labelStr)

  
  for i = 1:numel(obj.featuresUsed)
    fprintf('%d. %s\n', i, obj.featuresUsed{i})
  end
  
  saveas(gcf,'FIGS/featureMat-pairwise-correlation-threshold.pdf','pdf')  
  
  % Just as a double check
  if(1)
    figure
    imagesc(R)
    axis equal
    axis tight
    set(gca,'xtick',1:size(R,2))
    set(gca,'ytick',1:size(R,1))
  end
    
  return
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  plotCtr = 1;
  
  fontSize = 4;

  figure
  
  for i = 1:nFeatures
    for j = 1:nFeatures
      
      i,j
      
      subplot(nFeatures,nFeatures,plotCtr)
      plotCtr = plotCtr + 1;
      
      plot(obj.featureMat(:,i),obj.featureMat(:,j), ...
           '.', 'color', getColour(R(i,j)), ...
           'markersize', getMarkerSize(R(i,j)));
      
      a = axis();
      
      h = text(0.1*(a(2)-a(1))+a(1),0.8*(a(4)-a(3))+a(3),...
               sprintf('%.3f', R(i,j)),'fontsize',fontSize);
      
      axis tight
      axis off
      
      % Column headers on top
      if(i == 1)
        h = text(0.5*(a(2)-a(1))+a(1),1.25*(a(4)-a(3))+a(3), ...
                 obj.featuresUsed{j},'fontsize',fontSize);
        set(h,'HorizontalAlignment','center');
      end
      
      % Add row headers
      if(j == 1)
        h = text(-0.3*(a(2)-a(1))+a(1),0*(a(4)-a(3))+a(3), ...
                 obj.featuresUsed{i}, 'rotation',90);
        set(h,'verticalalignment','middle','fontsize',fontSize)
      end
      
    end
  end
  
  if(profFlag)
    profile off
    profview
  end
  
  disp('Saving fig')
  saveas(gcf,'FIGS/featureMat-pairwise-correlation.pdf','pdf')
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function s = getMarkerSize(cVal)

    markerSize = [3 7];
    absCorrVals = [0 1];
  
    s = interp1(absCorrVals, markerSize, abs(cVal));
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function col = getColour(cVal)

    % Set up colour palette
    colours = [0 0 1; 0 0 0; 1 0 0];
    corrVals = [-1 0 1];
  
    for k = 1:3
      col(k) = interp1(corrVals,colours(:,k),cVal);
    end
  end

end