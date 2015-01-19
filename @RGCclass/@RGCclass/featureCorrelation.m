% Several of the features are strongly correlated

function featureCorrelation(obj,sortFlag)

  if(~exist('sortFlag'))
    sortFlag = 'alphabetic';
  end
  
  % markInclude = [1 2 3 8 12 13 14];
  markInclude = [1 3 4 6 7 9 14 15 16];

  % First calculate the feature matrix with all featues
  useFeatures = obj.allFeatureNames;
  obj.updateTables(useFeatures);

  % Next we need to find correlation between them

  cc = corrcoef(obj.featureMat);
  d = 1 - abs(cc);
  
  Z = linkage(d);

  cThresh = shuffledCorrCoeff(0.99);
  
  figure
  subplot(2,1,1)
  dendrogram(Z);
  subplot(2,1,2)
  for i = 1:numel(useFeatures)
    if(ismember(i,markInclude))
      col = [0 0 0];
    else
      col = [1 0 0];
    end
    
    text(0,-i,sprintf('%d. %s', i,useFeatures{i}),'color',col)
  end

  axis([0 1 -(numel(useFeatures)+1) 0])
  axis off
  
  saveas(gcf,'FIGS/Clustering-based-on-feature-corrcoeff.pdf','pdf')
  
  latexCorrMatrix(cThresh)
  % plotCorrMatrix()
  
  return
  
  %%%%%%%%%%%
  
  function plotCorrMatrix()
  
    plotCtr = 0;
    figure
  
    for i = 1:numel(useFeatures)
      for j = 1:numel(useFeatures)
        
        plotCtr = plotCtr + 1;
        
        if(i ~= j)
          sp(plotCtr) = subplot(numel(useFeatures),numel(useFeatures),plotCtr);
          
          col = [0 0 0];
          if(cc(i,j) > 0)
            col(1) = cc(i,j);
          else
            col(3) = -cc(i,j);
          end
        
          plot(obj.featureMat(:,i),obj.featureMat(:,j), ...
               'o', 'color', col)

          axis off

        
          if(i == 1)
            title(obj.featuresUsed{j})
          end
        
        end
      end
    end

    
    try
      for i = 1:numel(sp)
        if(get(sp(i),'children') ~= 1)
          pos = get(sp(i),'position');
          newPos = pos .* [1 1 1.4 1.4];
          set(sp(i),'position',newPos)
        end
      end
    catch e
      getReport(e)
      keyboard
    end
  end
  
  % keyboard
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function latexCorrMatrix(thresh)
    

    
    for i = 1:numel(obj.allFeatureNames)
      featureAbbrev{i} = obj.featureNameDisplayShort(obj.allFeatureNames{i});
    end
          
    % thresh = 0.7;

    fprintf('\\begin{sidewaystable}\n\\begin{tabular}{l%s}\n', ...
            repmat('r',1,numel(featureAbbrev)))

    
    ccNAN = cc + diag(NaN*diag(cc));
    
    switch(sortFlag)
      case 'alphabetic'
        alphaIdx = obj.getFeatureAlphabeticOrder();        
        reorderIdx = alphaIdx;
      case 'correlation'
        [~,reorderIdx] = sort(max(ccNAN),'descend');        
      otherwise
        % Unsorted 
        reorderIdx = 1:numel(obj.allFeatureNames)        
    end
    

    for i = 1:numel(useFeatures)
      fprintf('& %s', featureAbbrev{reorderIdx(i)})
    end
    fprintf('\\\\\n\\hline\n')
    
    
    for ii = 1:numel(useFeatures)
      for jj = 1:numel(useFeatures)

        if(jj > ii)
          % Only show lower triangular
          fprintf(' & ')
          continue
        end
        
        i = reorderIdx(ii);
        j = reorderIdx(jj);
        
        if(isnan(ccNAN(i,j)))
          val = '';
        else
          val = sprintf('%.2f',cc(i,j));
        end
        
        if(jj == 1)
          if(abs(cc(i,j)) > thresh)
            fprintf('%s (%s) & \\textbf{%s} ', obj.featureNameDisplay(useFeatures{i}), featureAbbrev{i}, val)
          else
            fprintf('%s (%s) & %s ', obj.featureNameDisplay(useFeatures{i}), featureAbbrev{i}, val)          
          end
        else
          if(abs(cc(i,j)) > thresh)
            fprintf('& \\textbf{%s} ', val)          
          else
            fprintf('& %s ', val)          
          end
        end
      end
      fprintf('\\\\\n')
    end
    fprintf('\\hline\n')
    
    
    fprintf('\\end{tabular}\n\\label{tab:corr}\\end{sidewaystable}\n')
    
    fprintf('Using P threshold %.2f\n', thresh)
    
    
    
    % for i = 1:numel(useFeatures)
    %   fprintf('%d - %s (%s)\n', i, useFeatures{i}, featureAbbrev{i})
    % end
    
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  function sccThresh = shuffledCorrCoeff(P)
    
    nRep = 1000;
    
    scc = zeros(nRep,1);
    
    for i = 1:nRep
      
      if(mod(i,100) == 0)
        fprintf('%d/%d\n', i, nRep)
      end
    
      M = corrcoef(obj.shuffledFeatureMat('shuffleWithinColumns'));
      M = abs(M - triu(NaN*M));
      
      scc(i) = max(M(:));

      
    end

    sortedSCC = sort(scc,'ascend');
    
    sccThresh = sortedSCC(ceil(P *nRep));
    
  end
  
end
