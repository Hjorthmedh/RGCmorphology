close all, clear all

data = load('RESULTS/ExhaustiveFeatureSearch-Sumbul-NaiveBayes-25.mat');

numFeatures = zeros(numel(data.featureListIdx),1);

for i = 1:numel(numFeatures)
  numFeatures(i) = numel(data.featureListIdx{i});
end

numFeaturesAll = repmat(numFeatures,1,size(data.corrFrac,2));


figure
p = boxplot(100*data.corrFrac(:),numFeaturesAll(:), ...
            'jitter',0,'outliersize',2,'colors',[0 0 0]);
set(p,'linewidth',1)
box off
xlabel(sprintf('\nNumber of Features'),'fontsize',12)
ylabel('Performance (%)','fontsize',12)
set(gca,'fontsize',10)
set(gca,'xtick',[5 10 15])
set(gca,'xticklabel',[5 10 15])  

set(gca,'xminortick','on')
set(gca,'yminortick','on')

axis([0 15.5 0 100]);
a = axis();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add random chance line

r = RGCclass(0);
r.lazyLoad();
Pcorrect = r.getRandomChance();

hold on
plot(a(1:2),100*Pcorrect*[1 1],'b--','linewidth',1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


set(gcf,'paperunits','centimeters')
set(gcf,'units','centimeters')
set(gcf,'papersize',[8 8])
set(gcf,'paperposition',[0 0 8 8])


%saveas(gcf,'FIGS/exhaustive-search-box-plot-Sumbul.pdf','pdf')
printA4('FIGS/exhaustive-search-box-plot-Sumbul.eps')