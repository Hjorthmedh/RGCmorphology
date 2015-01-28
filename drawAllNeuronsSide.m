% Draw depth histograms for all RGCs

close all, clear all

r = RGCclass(0);
r.lazyLoad();


nColumns = 3;
nRows = 5;   

nameList = {};
pHandles = [];

figFile = {};
figHandle = [];

minZ = inf;
maxZ = -inf;

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
      
      r.RGC(subIdx).plotStratification();
      pHandles(end+1) = gca;
      % set(gca,'ydir','reverse')
      title(num2str(ctr))
      
      a = axis();
      minZ = min(a(3),minZ);
      maxZ = max(a(4),maxZ);
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