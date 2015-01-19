% Generate data with runExhaustiveFeatureSearchSumbul.m

close all, clear all

excludeFeature = {'somaArea'};

% data = load('RESULTS/ExhaustiveFeatureSearch-Sumbul-NaiveBayes-1.mat');
data = load('RESULTS/ExhaustiveFeatureSearch-Sumbul-NaiveBayes-25.mat');

excludeFeatureIdx = [];

for i = 1:numel(excludeFeature)
  for j = 1:numel(data.allFeatureNames)
    if(strcmpi(excludeFeature{i},data.allFeatureNames{j}))
      excludeFeatureIdx(i) = j;
    end
  end
end


goodFeatureSet = zeros(numel(data.featureListIdx),1);

for i = 1:numel(data.featureListIdx)
  if(all(~ismember(excludeFeatureIdx,data.featureListIdx{i})))
    goodFeatureSet(i) = 1;
  end
end

goodFeatureSetIdx = find(goodFeatureSet);

% Here we filter out those with the bad feature vectors
[~,bestIdx] = sort(data.corrFracMean(goodFeatureSetIdx),'descend');
bestIdx = goodFeatureSetIdx(bestIdx);


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

nFeaturesMax = numel(unique(data.allFeatureNames)) - numel(excludeFeatureIdx);

meanPerf = zeros(nFeaturesMax,1);
medianPerf = zeros(nFeaturesMax,1);
topPerf = zeros(nFeaturesMax,1);

for i = 1:nFeaturesMax
  nFeatIdx = find(nFeatures == i);
  % Note that the bestIdx already has filtered out the bad features
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

  nFeatIdxFiltered = intersect(nFeatIdx,goodFeatureSetIdx);
  
  meanPerf(i) = mean(data.corrFracMean(nFeatIdxFiltered));
  medianPerf(i) = median(data.corrFracMean(nFeatIdxFiltered));  
  % topPerf(i) = prctile(data.corrFracMean(nFeatIdxFiltered),99);
  topPerf(i) = max(data.corrFracMean(nFeatIdxFiltered));  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Had forgotten to add this one when we were running earlier
data.featureNameDisplay('dendriticDiameter') = 'Dendritic Diameter';            

data.featureNameDisplayShort = containers.Map();
data.featureNameDisplayShort('stratificationDepth') = 'SD';
data.featureNameDisplayShort('biStratificationDistance') = 'BD';
data.featureNameDisplayShort('dendriticField') = 'DA';
data.featureNameDisplayShort('densityOfBranchPoints') = 'DBP';
data.featureNameDisplayShort('somaArea') = 'SA';
data.featureNameDisplayShort('numBranchPoints') = 'NBP';
data.featureNameDisplayShort('numSegments') = 'NS';
data.featureNameDisplayShort('totalDendriticLength') = 'TDL';
data.featureNameDisplayShort('meanSegmentLength') = 'MSL';
data.featureNameDisplayShort('meanTerminalSegmentLength') = 'MTSL';
data.featureNameDisplayShort('meanSegmentTortuosity') = 'MST';
data.featureNameDisplayShort('meanBranchAngle') = 'MBA';
data.featureNameDisplayShort('dendriticDensity') = 'DD';
data.featureNameDisplayShort('fractalDimensionBoxCounting') = 'FDBC';      
data.featureNameDisplayShort('stratificationDepthScaled') = 'SDS';      
data.featureNameDisplayShort('dendriticVAChT') = 'DVAChT';      
data.featureNameDisplayShort('branchAssymetry') = 'BA';      
data.featureNameDisplayShort('numLeaves') = 'NL';            
data.featureNameDisplayShort('dendriticDiameter') = 'DDi';            
     

fid = fopen('RESULTS/ExhaustiveSearchLatex-excluded-features-Sumbul.tex','w');
% Number of features, 
fprintf(fid,'\\begin{sidewaystable}\n');                     
fprintf(fid,'\\begin{tabular}{cc%s}\n',repmat('l',1,numel(bestNfeatureSets)));


for i = 1:numel(data.allFeatureNames)
  allFeaturesShortOrig{i} = data.featureNameDisplayShort(data.allFeatureNames{i});
end
[allFeaturesShort,alphabeticIdx] = sort(allFeaturesShortOrig);

% Filter out excluded feature
%goodAlphaIdx = find(~ismember(alphabeticIdx,excludeFeatureIdx));
% allFeaturesShort = allFeaturesShort(goodAlphaIdx);
% alphabeticIdx = alphabeticIdx(goodAlphaIdx);


headerStr = [];
for i = 1:numel(allFeaturesShort)
  headerStr = sprintf('%s & %s', headerStr, allFeaturesShort{i});
end

fprintf(fid,'Number of features & Performance %s\\\\\n', headerStr);
fprintf(fid,'\\hline\n');

for i = 1:numel(bestNfeatureSets)
  
  featureMask = zeros(1,numel(data.allFeatureNames));
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



% Also write a CSV file


csvRowHeader = num2cell(1:numel(bestNfeatureSets));
for i = 1:numel(csvRowHeader)
  csvRowHeader{i} = num2str(csvRowHeader{i});
end

fid = fopen('RESULTS/ExhaustiveFeatureSearchPick-Sumbul.csv','w');

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
try
  featureMaskSorted = featureMask(alphabeticIdx);
catch e
  getReport(e)
  keyboard
end
  
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
x = x(goodFeatureSetIdx,:);
xr = x + (1-2*rand(size(x)))*0.35;
%plot(xr,data.corrFrac*100,'.','color',[1 1 1]*0.8)
plot(xr,data.corrFrac(goodFeatureSetIdx,:)*100,'.','color',[1 1 1]*0.8)
plot(nFeatures,data.corrFracMean*100,'k.')
plot(1:nFeaturesMax,medianPerf*100,'r-','linewidth',2)

axis([0 nFeaturesMax+0.5 0 100])
xlabel('No.','fontsize',24)
ylabel('Performance (%)','fontsize',24)
set(gca,'fontsize',20)

saveas(gcf,'FIGS/ExhaustiveFeatureSearch-performance-overview-Sumbul.pdf','pdf')

figure
hold on
x = kron(nFeatures,ones(1,data.nRep));
xr = x + kron(ones(size(nFeatures)),linspace(-0.4,0.4,data.nRep));
xr = xr(goodFeatureSetIdx,:);
p = plot(transpose(xr),transpose(sort(data.corrFrac(goodFeatureSetIdx,:),2,'descend')*100), ...
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

saveas(gcf,'FIGS/ExhaustiveFeatureSearch-performance-overview-alt-Sumbul.pdf','pdf')


bestNfeatureSetsName = {};

for i = 1:numel(bestNfeatureSets)
  bestNfeatureSetsName{i} = data.allFeatureNames(bestNfeatureSets{i});
end

dataIdx = data.dataIdx;

save('RESULTS/exhaustiveSearchResultsSummary-Sumbul.mat', ...
     'bestNfeatureSets', ...
     'bestNfeatureSetsMean', ...
     'bestNfeatureSetsName', ...
     'bestNfeatureSetsSTD', ...
     'allFeaturesShort', ...
     'dataIdx')
