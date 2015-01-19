% This function does the benchmarking

clear all, close all

r = RGCclass(0);

r.lazyLoad();

summary = {};

methodUsed = {'NaiveBayes'}; %{'NaiveBayes','Bags'}
nRepMethods = [1000]; %[1000 10] % [1000 100]

featSet1 = { 'dendriticDensity', ...
             'somaArea', ...
             'dendriticField', ...
             'biStratificationDistance'};

featSet2 = { 'dendriticDensity', ...
             'somaArea', ...
             'fractalDimensionBoxCounting', ...
             'meanBranchAngle'};

featSet3 = { 'dendriticDensity', ...
             'somaArea', ...
             'fractalDimensionBoxCounting', ...
             'dendriticField'};

featSet4 = { 'dendriticDensity', ...
             'somaArea', ...
             'totalDendriticLength', ...
             'meanTerminalSegmentLength'};

% This is from checking all 4-tuples, using all features as candidates
% Features are scored individually based on how well the classifier
% performed when they were included. 200 repeats were done
featSet5 = { 'densityOfBranchPoints', 'meanTerminalSegmentLength', ...
             'somaArea', 'dendriticField' };

% This is from checking all 4-tuples, using all features as candidates
% but only looking at the top 30 classifiers for scoring. Features
% are scored individually
featSet6 = {'somaArea','fractalDimensionBoxCounting','meanTerminalSegmentLength','densityOfBranchPoints'};

% This is from counting number of features appearing in 80% or
% better classifications
featSet7 = {'somaArea','fractalDimensionBoxCounting','densityOfBranchPoints','meanTerminalSegmentLength'};


featSet8 = {'somaArea','meanSegmentLength','densityOfBranchPoints','totalDendriticLength'};

featSet9 = {'somaArea','meanTerminalSegmentLength','densityOfBranchPoints','totalDendriticLength'};

featSet10 = {'somaArea', 'fractalDimensionBoxCounting', 'meanTerminalSegmentLength'};

featSetEllese = {'somaArea','meanTerminalSegmentLength','densityOfBranchPoints'};

goodFiveFeatSet = { 'densityOfBranchPoints', ...
                    'dendriticField', ...
                    'somaArea', ...
                    'fractalDimensionBoxCounting', ...
                    'meanTerminalSegmentLength' };


% featuresUsed = {featSet1,featSet2,featSet3, featSet4, featSet5}
% featuresUsed = {featSet10,featSetEllese}
% featuresUsed = {featSet10}
featuresUsed = {goodFiveFeatSet}

for im = 1:numel(methodUsed)
  for ifs = 1:numel(featuresUsed)
    
    feat = featuresUsed{ifs};
    
    r.setFeatureMat(feat);
    r.classifierMethod = methodUsed{im};
    
    [fracCorr,fracCorrSD,~,~,~,mu,sigma] = r.benchmark(nRepMethods(im));

    summary{end+1} = {r.featuresUsed,r.classifierMethod,fracCorr,fracCorrSD};
    
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for i = 1:numel(summary)
  
  for j = 1:numel(summary{i}{1})
    fprintf('%s ', summary{i}{1}{j})
  end
  
  corrFrac = summary{i}{3};
  corrFracSEM = summary{i}{4};
  
  fprintf('\nMethod: %s, %.4f +/- %.4f %%\n', ...
          summary{i}{2}, 100*corrFrac, 100*corrFracSEM)
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(numel(featuresUsed) == 1 & numel(methodUsed) == 1 & strcmpi(methodUsed,'NaiveBayes'))
  % Plot all the components
  figure
  plotCtr = 1;
  ax = [];
  
  xmin = inf*ones(size(mu,2));
  xmax = -inf*ones(size(mu,2));
  
  for i = 1:size(mu,1)
    for j = 1:size(mu,2)
  
      m = mu(i,j,:);
      ax(i,j) = subplot(size(mu,1),size(mu,2),plotCtr)
      hist(m(:),50)
      
      a = axis();
      xmin(j) = min(xmin(j),a(1));
      xmax(j) = max(xmax(j),a(2));
      
      if(i == 1)
        title(r.featureNameDisplayShort(r.featuresUsed{j}))
      end
      
      if(j == 1)
        idx = find(r.RGCtypeID == i);
        ylabel(r.RGCtypeName(idx(1)));
      end
      
      plotCtr = plotCtr + 1;
    end
  end
  
  for i = 1:size(mu,1)
    for j = 1:size(mu,2)
      set(ax(i,j),'xlim',[xmin(j) xmax(j)]);
    end
  end
      
  saveas(gcf,'FIGS/NaiveBayes-parameter-variation-mean.pdf','pdf')

  figure
  plotCtr = 1;
  ax = [];
  
  xmin = inf*ones(size(mu,2),1);
  xmax = -inf*ones(size(mu,2),1);
  
  
  for i = 1:size(sigma,1)
    for j = 1:size(sigma,2)
  
      s = sigma(i,j,:);
      ax(i,j) = subplot(size(sigma,1),size(sigma,2),plotCtr);
      hist(s(:),50)

      a = axis();
      xmin(j) = min(xmin(j),a(1));
      xmax(j) = max(xmax(j),a(2));
      
      if(i == 1)
        title(r.featureNameDisplayShort(r.featuresUsed{j}))
      end

      if(j == 1)
        idx = find(r.RGCtypeID == i);
        ylabel(r.RGCtypeName(idx(1)));
      end
      
      
      plotCtr = plotCtr + 1;
    end
  end

  for i = 1:size(mu,1)
    for j = 1:size(mu,2)
      set(ax(i,j),'xlim',[xmin(j) xmax(j)]);
    end
  end
  
  saveas(gcf,'FIGS/NaiveBayes-parameter-variation-SD.pdf','pdf')
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%