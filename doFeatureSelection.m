% This generates the plots and txt files with all feature landscapes

clear all, close all
if(1)
	r = RGCclass(0);
  r.lazyLoad();
else
	r = RGCclass(-1);
  r.lazySave();
end
met = {'naiveBayes', 'Bag', 'LPBoost', 'AdaBoostM2', ...
			 'TotalBoost', 'RUSBoost', 'SubspaceKNN'}

met = {'naiveBayes', 'Bag'};

for i = 1:numel(met)
	fS{i} = r.featureSelection(met{i},'showLandscape')
end
