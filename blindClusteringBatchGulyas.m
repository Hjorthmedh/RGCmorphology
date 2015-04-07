close all, clear all

r = RGCclass(0); r.lazyLoad('Gulyas');

figVis = 'off';

useFeatures = { 'dendriticField', ...
                'fractalDimensionBoxCounting', ...
                'meanSegmentLength', ...
                'totalDendriticLength', ...
                'meanSegmentTortuosity' };



% useFeaturesAlt = { 'branchAssymetry', ...
%                    'dendriticDensity', ...
%                    'dendriticDiameter', ...
%                    'dendriticField', ...
%                    'densityOfBranchPoints', ...
%                    'fractalDimensionBoxCounting', ...
%                    'meanBranchAngle', ...
%                    'meanTerminalSegmentLength', ...
%                    'numBranchPoints', ...
%                    'numSegments', ...
%                    'somaArea', ... 
%                    'totalDendriticLength' };

r.setFeatureMat(useFeatures);
% r.setFeatureMat(useFeaturesAlt);

% yVar = 'densityOfBranchPoints';
yVar = 'totalDendriticLength';
xVar = 'meanSegmentTortuosity';

x = r.getVariable(xVar);
y = r.getVariable(yVar);

marker = '+o*.xsdv><ph';

kMax = 20;

silMean = [];

RG = RGCgui(r);

allClusterID = {};

% Choose how many clusters we want to use in this figure
for k = 1:kMax

  if(k == 1)
    clusterID = r.RGCtypeID;
    kMax = 5;
  else
    clusterID = r.blindClustering(k);
    kMax = k;
  end
  
  allClusterID{k} = clusterID;
  
  figure('visible','off')
  % subplot(1,2,1)
  [s,h] = silhouette(r.featureMat,clusterID);
  box off

  silMean(k) = mean(s);
  
  set(gca,'fontsize',20)
  set(get(gca,'xlabel'),'fontsize',25)
  set(get(gca,'ylabel'),'fontsize',25)
  
  if(k == 1)
    set(gca,'yticklabel',r.RGCuniqueNames)
  end
  
  
  if(k == 1)
    fName = 'FIGS/Gulyas-Silhouette-measure-genetic-marker-silhouette.pdf';
  else
    fName = sprintf('FIGS/Gulyas-Silhouette-measure-k-%d-silhouette.pdf',k);
  end
  saveas(gcf,fName,'pdf')
  
  
  figure('visible',figVis)
  % subplot(1,2,2)
  
  p = [];
  pLeg = {};
  
  if(k == 1)
  
    for i = 1:numel(r.RGCuniqueIDs)
    
      idx = find(clusterID == r.RGCuniqueIDs(i));
      p(i) = plot(x(idx),y(idx), ...
                  '.', 'markersize', 20,...
                  'color', RG.classColours(r.RGCuniqueIDs(i),:));
      hold all
      pLeg{i} = r.RGCuniqueNames{i};
    end
  else
    
    for i = 1:kMax
    
      idx = find(clusterID == i);
    
      p(i) = plot(x(idx),y(idx),marker(mod(i-1,numel(marker))+1));
      hold all
    
      pLeg{i} = num2str(i);
    
    end
    
  end
  
  legend(p,pLeg,'location','northeastoutside')
  
  xlabel(r.featureNameDisplay(xVar),'fontsize',25)
  ylabel(r.featureNameDisplay(yVar),'fontsize',25)
  
  axis tight
  box off
  
  set(gca,'fontsize',20)

  
  if(k == 1)
    fName = 'FIGS/Gulyas-Silhouette-measure-genetic-marker-feature-space.pdf';
  else
    fName = sprintf('FIGS/Gulyas-Silhouette-measure-k-%d-feature-space.pdf',k);
  end
  saveas(gcf,fName,'pdf')
  
end

% I have been bad.
% k = 1, is real data, with five clusters, so need to plot that
% point separately.
%

% Summarise the silhouette values
figure('visible','on')
hb = plot(2:kMax,silMean(2:kMax),'k-','linewidth',2); hold on
hr = plot(numel(r.RGCuniqueIDs),silMean(1),'r.','markersize',20);

xlabel('Number of clusters','fontsize',12)
ylabel('Mean silhouette value','fontsize',12)

legend([hb hr], 'Blind clustering', 'Genetically marked', ...
       'location','northeast')
set(gca,'fontsize',10)
a = axis;
a(1) = 2;
a(3) = 0; a(4) = 1;
axis(a);

set(gca,'xminortick','off')
set(gca,'yminortick','off')
set(gca,'xtick',2:1:20)
set(gca,'ytick',0:0.1:1)
set(gca,'xticklabel', {'2','','','5', ...
                       '','','','','10', ...
                       '','','','','15', ...    
                       '','','','','20' })
set(gca,'yticklabel', {'0','','','','','0.5', ...
                       '','','','','1'})

box off

set(gcf,'paperunits','centimeters')
set(gcf,'units','centimeters')
set(gcf,'papersize',[8 8])
set(gcf,'paperposition',[0 0 8 8])

%saveas(gcf,'FIGS/Gulyas-Silhouette-measure-summary.pdf','pdf')
printA4('FIGS/Gulyas-Silhouette-measure-summary.eps')

%
% Last thing we want to make a plot to show how the blind clusters
% and the genetic clusters relate to each other.
%

for nClust = [2 3 5];
  clusterID = allClusterID{nClust};

  IDmatrix = zeros(numel(r.RGCuniqueNames),nClust);

  for i = 1:numel(r.RGC)

    IDmatrix(r.RGCtypeID(i),clusterID(i)) = ...
        IDmatrix(r.RGCtypeID(i),clusterID(i)) + 1;
  
  end

  columnHeaders = {};
  for i = 1:nClust
    columnHeaders{i} = num2str(i);
  end


  str = makeLatexTableHeaders(columnHeaders,r.RGCuniqueNames,IDmatrix,'%d','Blind Cluster','Genetic Type')
  str2 = strrep(str,'\','\\');
  
  
  fName = sprintf('RESULTS/Gulyas-BlindClustering-latex-n-%d.tex', nClust);
  fid = fopen(fName,'w');
  fprintf(fid,str2);
  fclose(fid);
end

