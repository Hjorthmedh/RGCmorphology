close all, clear all

disp('Make sure it runs with right data file')
data = load('RESULTS/ExhaustiveFeatureSearch-Gulyas-NaiveBayes-20.mat');

[~,bestIdx] = sort(data.corrFracMean,'descend');

% Show top 10
for i = 1:10
  bi = bestIdx(i);
  fprintf('%d. %.1f +/- %.1f % :', ...
          i, 100*data.corrFracMean(bi), ...
          100*data.corrFracSD(bi))

  for j = 1:numel(data.featureListIdx{bi})
    fprintf('%s ', data.allFeatureNames{data.featureListIdx{bi}(j)})
  end
  fprintf('\n')
end

% Show best N feature set

bestNfeatureSets = {};
bestNfeatureSetsMean = [];
bestNfeatureSetsSTD = [];

nFeatures = zeros(numel(data.featureListIdx),1);

for i = 1:numel(data.featureListIdx)
  nFeatures(i) = numel(data.featureListIdx{i});
end

nFeaturesMax = max(nFeatures);

meanPerf = zeros(nFeaturesMax,1);
medianPerf = zeros(nFeaturesMax,1);
topPerf = zeros(nFeaturesMax,1);

for i = 1:nFeaturesMax
  nFeatIdx = find(nFeatures == i);
  bi = find(ismember(bestIdx,nFeatIdx));
  nFeatBestIdx = bestIdx(bi(1));
  
  bestNfeatureSets{i} = data.featureListIdx{nFeatBestIdx};
  bestNfeatureSetsMean(i) = data.corrFracMean(nFeatBestIdx);
  bestNfeatureSetsSTD(i) = data.corrFracSD(nFeatBestIdx);
  
  fprintf('%d (%d features). %.1f +/- %.1f % :', ...
          bi(1), i, 100*data.corrFracMean(nFeatBestIdx), ...
          100*data.corrFracSD(nFeatBestIdx))

  for j = 1:numel(data.featureListIdx{nFeatBestIdx})
    fprintf('%s ', data.allFeatureNames{data.featureListIdx{nFeatBestIdx}(j)})
  end
  fprintf('\n')

  meanPerf(i) = mean(data.corrFracMean(nFeatIdx));
  medianPerf(i) = median(data.corrFracMean(nFeatIdx));  
  % topPerf(i) = prctile(data.corrFracMean(nFeatIdx),99);
  topPerf(i) = max(data.corrFracMean(nFeatIdx));  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Had forgotten to add this one when we were running earlier
r2 = RGCclass(0);
r2.setNameLookup();     

data.featureNameDisplay = r2.featureNameDisplay;
data.featureNameDisplayShort = r2.featureNameDisplayShort;     

fid = fopen('RESULTS/ExhaustiveSearchLatex.tex','w');
% Number of features, 
fprintf(fid,'\\begin{sidewaystable}\n');                     
fprintf(fid,'\\begin{tabular}{cc%s}\n',repmat('l',1,numel(bestNfeatureSets)));


for i = 1:numel(data.allFeatureNames)
  allFeaturesShortOrig{i} = data.featureNameDisplayShort(data.allFeatureNames{i});
  allFeaturesLongOrig{i} = data.featureNameDisplay(data.allFeatureNames{i});
end

% Sorting by long names...
%[allFeaturesShort,alphabeticIdx] = sort(allFeaturesShortOrig);
[allFeaturesLong,alphabeticIdx] = sort(allFeaturesLongOrig);
allFeaturesShort = allFeaturesShortOrig(alphabeticIdx);

headerStr = [];
for i = 1:numel(allFeaturesShort)
  headerStr = sprintf('%s & %s', headerStr, allFeaturesShort{i});
end

fprintf(fid,'Number of features & Performance %s\\\\\n', headerStr);
fprintf(fid,'\\hline\n');

for i = 1:numel(bestNfeatureSets)
  
  featureMask = zeros(1,numel(bestNfeatureSets));
  featureMask(bestNfeatureSets{i}) = 1;
  featureMaskSorted = featureMask(alphabeticIdx);
  
  featureStr = [];
  for j = 1:numel(featureMaskSorted);
    if(featureMaskSorted(j))
      featureStr = sprintf('%s & $\\bullet$', featureStr);
    else
      featureStr = sprintf('%s & ', featureStr);
    end
  end
    
  fprintf(fid,'%d & $%.1f \\pm %.1f\\,\\%%$ %s\\\\\n', ...
          i, bestNfeatureSetsMean(i)*100, bestNfeatureSetsSTD(i)*100, ...
          featureStr);
  

end
  
fprintf(fid,'\\hline\n');
fprintf(fid,'\\end{tabular}\n');

captionStr = sprintf('%s (%s)', ...
                     data.featureNameDisplay(data.allFeatureNames{alphabeticIdx(1)}), ...
                     data.featureNameDisplayShort(data.allFeatureNames{alphabeticIdx(1)}));

for i = 2:numel(alphabeticIdx)
  captionStr = sprintf('%s, %s (%s)', ...
                       captionStr, ...
                       data.featureNameDisplay(data.allFeatureNames{alphabeticIdx(i)}), ...
                       data.featureNameDisplayShort(data.allFeatureNames{alphabeticIdx(i)}));
  
end
                     
fprintf(fid, '\\caption{%s}\n', captionStr);
fprintf(fid,'\\end{sidewaystable}\n');

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Also write a CSV file


csvRowHeader = num2cell(1:numel(bestNfeatureSets));
for i = 1:numel(csvRowHeader)
  csvRowHeader{i} = num2str(csvRowHeader{i});
end

fid = fopen('RESULTS/ExhaustiveFeatureSearchPick.csv','w');

fprintf(fid, 'No.,Performance');
for i = 1:numel(allFeaturesShort)
  fprintf(fid,', %s', allFeaturesShort{i});
end
fprintf(fid,'\n');

for i = 1:numel(bestNfeatureSets)
  
  fprintf(fid,'%d, %.1f +/- %.1f', i, ...
          bestNfeatureSetsMean(i)*100, ...
          bestNfeatureSetsSTD(i)*100);
  
  featureMask = zeros(1,numel(bestNfeatureSets));
  featureMask(bestNfeatureSets{i}) = 1;
  featureMaskSorted = featureMask(alphabeticIdx);
  
  for j = 1:numel(featureMaskSorted)
    if(featureMaskSorted(j))
      fprintf(fid,',+');
    else
      fprintf(fid,', ');
    end
  end
  
  fprintf(fid,'\n');
  
end

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the number of features versus the performance

figure
hold on
x = kron(nFeatures,ones(1,data.nRep));
xr = x + (1-2*rand(size(x)))*0.35;
plot(xr,data.corrFrac*100,'.','color',[1 1 1]*0.8)
plot(nFeatures,data.corrFracMean*100,'k.')
plot(1:nFeaturesMax,medianPerf*100,'r-','linewidth',2)

axis([0 nFeaturesMax+0.5 0 100])
xlabel('No.','fontsize',24)
ylabel('Performance (%)','fontsize',24)
set(gca,'fontsize',20)

saveas(gcf,'FIGS/ExhaustiveFeatureSearch-performance-overview.pdf','pdf')

figure
hold on
x = kron(nFeatures,ones(1,data.nRep));
xr = x + kron(ones(size(nFeatures)),linspace(-0.4,0.4,data.nRep));
p = plot(transpose(xr),transpose(sort(data.corrFrac,2,'descend')*100), ...
         '-','color',[1 1 1]*0.8,'markersize',4);
for i = 1:numel(p)
  set(p(i),'color',[1 1 1]*(0.6+0.3*rand(1)))
end

plot(nFeatures,data.corrFracMean*100,'k.')
plot(1:nFeaturesMax,medianPerf*100,'r-','linewidth',2)
% plot(1:nFeaturesMax,topPerf*100,'r-','linewidth',2)

axis([0 nFeaturesMax+0.5 0 100])
xlabel('Number of features','fontsize',24)
ylabel('Performance (%)','fontsize',24)
set(gca,'fontsize',20)

axis([0 15.5 0 100])

saveas(gcf,'FIGS/ExhaustiveFeatureSearch-performance-overview-alt.pdf','pdf')


bestNfeatureSetsName = {};

for i = 1:numel(bestNfeatureSets)
  bestNfeatureSetsName{i} = data.allFeatureNames(bestNfeatureSets{i});
end

dataIdx = data.dataIdx;

save('RESULTS/exhaustiveSearchResultsSummary.mat', ...
     'bestNfeatureSets', ...
     'bestNfeatureSetsMean', ...
     'bestNfeatureSetsName', ...
     'bestNfeatureSetsSTD', ...
     'allFeaturesShort', ...
     'dataIdx')
