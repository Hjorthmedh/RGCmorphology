% This script just outputs the RGC sorted by dendritc area and soma
% area, to ask Rana if this correlates with the eccentricity

close all, clear all

r = RGCclass(0);
r.lazyLoad();

rg = RGCgui(r);
colours = rg.classColours;

% Need to change to the 5-feature set if we want to do any
% classification, but for this we dont care at the moment...

dendArea = r.getVariable('dendriticField');
somaArea = r.getVariable('somaArea');

% Plot their correlation

figure, hold on
for i = 1:numel(r.RGC)
  p(r.RGCtypeID(i)) = plot(dendArea(i),somaArea(i),'.', ...
                           'color', colours(r.RGCtypeID(i),:));
  pLeg{r.RGCtypeID(i)} = r.RGCtypeName{i};
end

legend(p,pLeg)

xlabel('Dendritic Area')
ylabel('Soma Area')

figure, hold on
for i = 1:numel(r.RGC)
  p(r.RGCtypeID(i)) = plot(dendArea(i),r.RGCtypeID(i),'.', ...
                           'color', colours(r.RGCtypeID(i),:), ...
                           'markersize', 30);
  pLeg{r.RGCtypeID(i)} = r.RGCtypeName{i};
end
xlabel('Dendritic Area','fontsize',24)
set(gca,'ytick',1:5)
set(gca,'yticklabel',pLeg)
set(gca,'fontsize',24)
saveas(gcf,'FIGS/dendriticArea-range.pdf','pdf')

a = axis; a(3) = 0.5; a(4) = 5.5; axis(a);

for id = 1:5
  
  idx = find(r.RGCtypeID == id);
  [~,sortIdx] = sort(dendArea(idx),'descend');

  for j = 1:numel(sortIdx)
    k = idx(sortIdx(j));
    
    fprintf('%s area: %.0f - %s\n', ...
            r.RGCtypeName{k}, ...
            r.RGC(k).stats.dendriticField, ...
            r.RGC(k).xmlFile)
  
  end
    
  fprintf('\n')
  
end