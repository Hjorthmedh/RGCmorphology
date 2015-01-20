clear all, close all

disp('Setting random seed...')
beep
rng(1)

center = [0 0; 1 1; 0.5 2] + 2;

spread = [0.2 3 0.7];

nDots = 30;

color = [27,158,119;
         217,95,2;
         117,112,179] / 255;


fNameMask = 'FIGS/cartoon-cluster-separation-summary.eps'
% fNameMask = 'FIGS/cartoon-cluster-separation-summary.pdf'

showText = {'No overlaps','Large overlaps','Moderate overlaps'}

figure


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nPanels = 3; %4

if(nPanels == 4)
  subplot(nPanels,1,1)

  r = RGCclass(0);
  r.lazyLoad();
  r.RGC(1).drawNeuron(true,false)
  
  axis tight
  a = axis();
  text(a(1) - 0.2 * (a(2)-a(1)), ...
       a(4),char('A'), ...
       'fontsize', 24)
  axis off
  title('')
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xMean = zeros(3,1);
yMean = zeros(3,1);

markers = '.vs';
markersize = [9 4 4];
for i = 1:3
  if(nPanels == 4)
    subplot(nPanels,1,i+1)    
  else
    subplot(nPanels,1,i)
  end
  
  for j = 1:3
    
    x = spread(i)*randn(nDots,1) + center(j,1);
    y = spread(i)*randn(nDots,1) + center(j,2);
    
    pl(j) = plot(x,y,markers(j),'color',color(j,:),'markersize',markersize(j))
    hold on
    
    xMean(j) = mean(x);
    yMean(j) = mean(y);
    
    % plot(xMean(j),yMean(j),'*','color',color(j,:))
    % text(xMean(j),yMean(j),num2str(j))
    
  end

  if(i == 3)
    xq = 1.5; yq = 2.5;
    pl(4) = plot(xq,yq,'k.','markersize',15)
    text(xq-0.45,yq,'?','fontsize',15)
  end
 
  
  if(i == 3)
    legend(pl,{'Type 1','Type 2', 'Type 3','Unknown type'})
  end
  
  
  box off
  
  set(gca,'xtick',[])
  set(gca,'ytick',[])
  
  if(i == 3)
    xlabel('Dendritic Area','fontsize',10)
  end
  ylabel('Soma Size','fontsize',10)
    
  set(gca,'fontsize',8)
  pos = get(gca,'position');
  pos(3) = pos(3)/3;
  set(gca,'position',pos)

  axis tight 
  
  
  [vx,vy] = voronoi(xMean,yMean);
  
  k = 5;
  vx(3,:) = k*(vx(2,:) - vx(1,:)) + vx(1,:);
  vy(3,:) = k*(vy(2,:) - vy(1,:)) + vy(1,:);  
  
  plot(vx,vy,'k--')
  

  a = axis();

  text(a(1) - 0.20 * (a(2)-a(1)), ...
       a(4),char('A' + i - 1), ...
       'fontsize', 24)
  
  t = text(a(2),a(4)+0.1*(a(4)-a(1)),showText{i}, ...
           'fontangle','italic', ...
           'horizontalalignment','right','fontsize',10);




  
end


ch = get(gcf,'children')

for i = 1:4
  p(i,:) = get(ch(i),'position');
end

w = 0.70; h = 0.2;
s = 0.05;

set(gcf,'paperunits','centimeters')
set(gcf,'units','centimeters')
set(gcf,'papersize',[6 24])
set(gcf,'paperposition',[0 0 6 24])

% set(ch(1),'position',[0.2 s         w h])
% set(ch(2),'position',[0.2 (2*s+h)   w h])
% set(ch(3),'position',[0.2 (3*s+2*h) w h])
% set(ch(4),'position',[0.2 (4*s+3*h) w h])

 set(ch(2),'position',[0.2 s         w h])
 set(ch(3),'position',[0.2 (2*s+h)   w h])
 set(ch(4),'position',[0.2 (3*s+2*h) w h])
 set(ch(1),'position',[0.2 (4*s+3*h-0.08) w h])
 
 
for i = [2 3 4]
  pbaspect(ch(i),[1 1 1])
end



fName = sprintf(fNameMask,i);
% saveas(gcf,fName,'eps')
% print(fName,'-dpdf','-r300')
printA4(fName)



