% This script draws all the neurons with the same scale

close all, clear all

r = RGCclass(0);
r.lazyLoad();


nColumns = 3;
nRows = 5;   
spacing = 500;

axisRange = [-spacing/2, nColumns*spacing+spacing/2, -nRows*spacing+spacing/2, 0.7*spacing];

nameList = {};

for i = 1:numel(r.RGCuniqueNames)
  figure
  hold on
  plot([0 100],-spacing/2*[1 1],'k-','linewidth',2)
  showType = r.RGCuniqueNames{i};

  pageCtr = 1;
  
  idx = find(ismember(r.RGCtypeName,{showType}));

  x = 0; y = 0;
  ctr = 1;
  
  while(ctr <= numel(idx))
    if(x > spacing*nColumns)
      x = 0;
      y = y - spacing;
    end
    
    if(y < - spacing * nRows)
      % Save old figure
      axis(axisRange)
      axis off
      fName = sprintf('FIGS/%s-all-cells-%d.eps',showType,pageCtr);
      printA4(fName);

      
      % Start new figure
      y = 0;
      axis(axisRange)
      figure % New figure
      hold on
      plot([0 100],-spacing/2*[1 1],'k-','linewidth',2)

      pageCtr = pageCtr + 1;
    end
    
    r.RGC(idx(ctr)).drawNeuron(1,0,[x y 0],0);
    nameList{i}{ctr} = r.RGC(idx(ctr)).xmlFile;
    
    text(x-0.45*spacing,y+0.45*spacing,num2str(ctr))
    %text(x,y+spacing/2,r.RGC(idx(ctr)).xmlFile, ...
    %     'horizontalalignment','center','fontsize',4)
    
    ctr = ctr + 1;
    x = x + spacing;
    title(showType,'fontsize',18)
  end

  
  axis(axisRange)
  axis off
  
  fName = sprintf('FIGS/%s-all-cells-%d.eps',showType,pageCtr);
  printA4(fName);
  
end



% Write list of files to file

fid = fopen('FIGS/List-of-files-in-all-cells-figure.txt','w');
for i = 1:numel(nameList)
  fprintf(fid,'%s\n\n', r.RGCuniqueNames{i})
  for j = 1:numel(nameList{i})
    fprintf(fid,'%d. %s\n', j, strrep(nameList{i}{j},'.xml',''))
  end
  
  fprintf(fid,'\n\n')
end

fclose(fid)
