close all, clear all


data = load('RESULTS/exhaustiveSearchResultsSummary-Sumbul.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parfor i = 1:numel(data.bestNfeatureSetsName)

  fprintf('SVM Feature scan: %d/%d\n', i, numel(data.bestNfeatureSetsName))  
  
  r = RGCclass(0);
  r.lazyLoad('knownSumbul');
  r.classifierMethod = 'SVM';
  % r.verbose = 1;

  r.setFeatureMat(data.bestNfeatureSetsName{i});

  [SVMcorrectFracMean(i),SVMcorrectFracSD(i), SVMcorrectFrac(i,:), ...
   SVMclassifiedAsID(:,:,i),SVMcorrFlag(:,:,i)] = ...
      r.benchmark(size(data.dataIdx,2),data.dataIdx);
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parfor i = 1:numel(data.bestNfeatureSetsName)

  fprintf('BAGS Feature scan: %d/%d\n', i, numel(data.bestNfeatureSetsName))  
  
  r = RGCclass(0);
  r.lazyLoad('knownSumbul');
  r.classifierMethod = 'Bags';
  % r.verbose = 1;

  r.setFeatureMat(data.bestNfeatureSetsName{i});

  [BAGScorrectFracMean(i),BAGScorrectFracSD(i), BAGScorrectFrac(i,:), ...
   BAGSclassifiedAsID(:,:,i),BAGScorrFlag(:,:,i)] = ...
      r.benchmark(size(data.dataIdx,2),data.dataIdx);
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:numel(data.bestNfeatureSetsName)
  nFeat(i) = numel(data.bestNfeatureSetsName{i});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colours = [27,158,119;
           217,95,2;
           117,112,179]/255;

save('RESULTS/methodcomparison-KnownSumbul.mat','nFeat','data', ...
     'SVMcorrectFracMean', 'SVMcorrectFracSD', ...
     'BAGScorrectFracMean', 'BAGScorrectFracSD', ...
     'colours');

figure

pNB = errorbar(nFeat,100*data.bestNfeatureSetsMean,100*data.bestNfeatureSetsSTD, ...
              '-', 'linewidth', 1, 'color', colours(2,:));
hold on     
pSVM = errorbar(nFeat,100*SVMcorrectFracMean,100*SVMcorrectFracSD, ...
                '-', 'linewidth', 1, 'color', colours(1,:));

pBAGS = errorbar(nFeat,100*BAGScorrectFracMean,100*BAGScorrectFracSD, ...
                '-', 'linewidth', 1, 'color', colours(3,:));

xlabel('Number of Features','fontsize',12)
ylabel('Performance (%)','fontsize',12)
set(gca,'fontsize',10)
set(gca,'xminortick','off')
set(gca,'yminortick','off')

set(gca,'xtick',1:1:15)
set(gca,'ytick',0:10:100)
set(gca,'xticklabel', {'1','','','','5', ...
                       '','','','','10', ...
                       '','','','','15'});
set(gca,'yticklabel', {'0','','','','','50', ...
                       '','','','','100'});


legend([pNB(1) pSVM(1),pBAGS(1)], 'Naive Bayes', 'SVM', 'Bagging', 'location', 'east')
box off

axis([0 15.5 0 100])

% Add random chance line

a = axis();

r = RGCclass(0);
r.lazyLoad('knownSumbul');
Pcorrect = r.getRandomChance();

hold on
plot(a(1:2),100*Pcorrect*[1 1],'b--','linewidth',1)

set(gcf,'paperunits','centimeters')
set(gcf,'units','centimeters')
set(gcf,'papersize',[8 8])
set(gcf,'paperposition',[0 0 8 8])
% saveas(gcf,'FIGS/SVM-NaiveBayes-comparison-knownSumbul-DATA.pdf','pdf')
printA4('FIGS/SVM-NaiveBayes-comparison-knownSumbul-DATA.eps')




save('SVMcomparisonSavedState-knownSumbul.mat')


