% Draw depth histograms for all RGCs

close all, clear all

r = RGCclass(0);
r.lazyLoad();

nColumns = 5;
nRows = 3;   

nameList = {};
pHandles = [];

figFile = {};
figHandle = [];

minZ = 0;
maxZ = 0;

for i = 1:numel(r.RGCuniqueNames)

  showType = r.RGCuniqueNames{i};
  
  ctr = 1;
  idx = find(ismember(r.RGCtypeName,{showType}));

  for pageOfs = 1:(nColumns*nRows):numel(idx)

    figHandle(end+1) = figure();
    figFile{end+1} = sprintf('FIGS/%s-stratification-depth-%d.eps', ...
                             showType, pageOfs);
    
    for k = 1:min(nColumns*nRows,numel(idx)-pageOfs+1)
    
      subplot(nRows,nColumns,k)
      subIdx = idx(k + pageOfs - 1);
      
      [pHand,pMinZ,pMaxZ] = r.RGC(subIdx).plotStratification(true);
      pHandles(end+1) = gca;
      % set(gca,'ydir','reverse')
      title(num2str(ctr))
      set(gca,'fontsize',12)
      box off
      
      if(k == 1)
        xlabel([])
        ylabel('Z-depth (\mum)','fontsize',12)
      else
        xlabel([])
        ylabel([])
        set(gca,'ytick',[])
      end
      set(gca,'xtick',[])
      set(gca,'ydir','reverse')
      
      set(gca,'xcolor',get(gcf,'color'))
      
      %a = axis();
      %minZ = min(a(3),minZ);
      %maxZ = max(a(4),maxZ);
      
      minZ = min(minZ,pMinZ);
      maxZ = max(maxZ,pMaxZ);
      
      ctr = ctr + 1;
      
    end
    
  end
  
end


for i = 1:numel(pHandles)
  axes(pHandles(i))
  a = axis;
  
  a(3:4) = [minZ maxZ];
  axis(a);
  
end

for i = 1:numel(figHandle)
  set(0,'currentfigure',figHandle(i))
  printA4(figFile{i})
end