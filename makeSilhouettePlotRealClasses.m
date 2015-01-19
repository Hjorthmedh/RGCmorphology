close all, clear all

r = RGCclass(0); r.lazyLoad();

r.setFeatureMat(r.allFeatureNames);

[s,h] = silhouette(r.featureMat,r.RGCtypeID);

yLabel = {};

for i = 1:max(r.RGCtypeID)

  idx = find(r.RGCtypeID == i);
  yLabel{i} = r.RGCtypeName{idx(1)};
  
end

set(gca,'yticklabel',yLabel)

box off

set(gca,'fontsize',20)
set(get(gca,'xlabel'),'fontsize',25)
set(get(gca,'ylabel'),'fontsize',25)

saveas(gcf,'FIGS/Silhouette-values-real-data.pdf','pdf')