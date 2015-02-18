% Hoxd10 and Cdh3 are compromised of multiple subtypes, find out
% how many and how to split them

clear all, close all

% This is for Hoxd10 -- Pre Jan 2015
 RGCtoMark = {'Hoxd10-04022012.xml', ...
              'P25-Hoxd1007132012-r2-25x-06zoom.xml', ... % Single cell cluster, top right corner
              'Hoxd10-06082012-c1-corrected.xml' }

 % New
 RGCtoMark = {'Hoxd10-bothears-righteyecontrol-04302013-40x-cell1-09zoom.xml', ...
              'P25-Hoxd1007132012-r2-25x-06zoom.xml', ... % Single cell cluster, top right corner
              'Hoxd10-none-righteyecontrol-04292013-40x-cell5-stitch.xml' }

 % Moved the 3
 RGCtoMark = {'Hoxd10-bothears-righteyecontrol-04302013-40x-cell1-09zoom.xml', ...
              'P25-Hoxd1007132012-r2-25x-06zoom.xml', ... % Single cell cluster, top right corner
              'Hoxd10-none-righteyecontrol-04292013-40x-cell4-zoom07-stitch.xml' }

 
numOrder = [2 1 3];


typeID = 4; % 4 = Hoxd10, 2 = Cdh3
            % typeID = 2
nReps = 1000;

r = RGCclass(0);
r.lazyLoad();

% This uses the five default features

RGCidx = find(r.RGCtypeID == typeID);

fprintf('Features used (%s):\n', r.RGCtypeName{RGCidx(1)})
for i = 1:numel(r.featuresUsed)
  fprintf('%d. %s\n', i, r.featuresUsed{i})
end

kAll = 2:6;

silVal = zeros(numel(kAll),numel(RGCidx));

for kIdx = 1:numel(kAll)
  clusterID(kIdx,:) = r.blindClustering(kAll(kIdx), nReps, RGCidx);
  silVal(kIdx,:) = silhouette(r.featureMat(RGCidx,:),clusterID(kIdx,:));
end

silValMean = mean(silVal,2);

[~,bestKidx] = max(silValMean);
bestK = kAll(bestKidx);

figure, hold on
plot(kAll,silValMean,'k-')
xlabel('Number of clusters')
ylabel('Silhouette value')
plot(bestK,silValMean(bestKidx),'r*')

fName = sprintf('FIGS/Blind-%s-silhouette.eps',r.RGCtypeName{RGCidx(1)});
printA4(fName)


figure, hold on

[coeff,score,latent] = pca(r.featureMat(RGCidx,:));

uniqueID = unique(clusterID(bestKidx,:));
markerSize = [8 32 8 8 8]
symbols = 'o.*xv^';

rg = RGCgui(r);
colour = rg.classColours(typeID,:) ;

fprintf('PCA variance comp #1: %f (%.2f %%), comp #2 %f (%.2f %%)', ...
        latent(1),latent(1)/sum(latent)*100, latent(2),latent(2)/sum(latent)*100)

for i = 1:numel(uniqueID)
  
  idx = find(clusterID(bestKidx,:) == uniqueID(i));
  plot(score(idx,1),score(idx,2),'marker',symbols(i), ...
       'markersize', markerSize(i), ...
       'linestyle','none','color',colour)

  for j = 1:numel(idx)
    fprintf('Cluster %d: %s\n', uniqueID(i), ...
            r.RGC(RGCidx(idx(j))).xmlFile)
    
    memberFlag = ismember(RGCtoMark,r.RGC(RGCidx(idx(j))).xmlFile);
    if(any(memberFlag))
      k = find(memberFlag);
      assert(numel(k) == 1)
      text(score(idx(j),1)+0.15,score(idx(j),2), ...
           num2str(numOrder(k)),'fontsize',24)
      fprintf('Marking %s with as %d\n', r.RGC(RGCidx(idx(j))).xmlFile, ...
              numOrder(k))
    end
  end
  
  
  
end
set(gca,'ytick',[-2 0 2 4])

xlabel('PC #1','fontsize',20)
ylabel('PC #2','fontsize',20)
set(gca,'fontsize',20)
axis equal
pbaspect([1 1.5 1])
a = axis;
a(3:4) = [-2 4];
axis(a)

fName = sprintf('FIGS/Blind-%s-best-clustering.eps',r.RGCtypeName{RGCidx(1)});
printA4(fName)


return
%%%%%%%%%%%%%s

for i = 1:numel(uniqueID)
  idx = find(clusterID(bestKidx,:) == uniqueID(i));

  figure, hold on
  x = 0; y = 0; 
  
  if(numel(idx) == 13)
    plot([-200 -100], [-200 -200],'k-','linewidth',2)
  end
  
  for j = 1:numel(idx)

    r.RGC(RGCidx(idx(j))).drawNeuron(1,0,[x y 0]);
    x = x + 400;
    if(x > 1200)
      x = 0;
      y = y + 400;
    end
  end
  
  axis([-350 1650 -200 1400])
  axis off
  title([])
  
  fName = sprintf('FIGS/Blind-%s-best-clustering-group-%d.eps',r.RGCtypeName{RGCidx(1)},i);
  printA4(fName);
  
end