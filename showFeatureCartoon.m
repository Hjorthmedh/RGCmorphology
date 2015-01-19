clear all, close all

center = [0 0; 1 1; 0.5 2] + 2;

spread = [0.2 0.6 3];

nDots = 30;

color = [27,158,119;
         217,95,2;
         117,112,179] / 255;

fNameMask = 'FIGS/cartoon-cluster-separation-%d.pdf'

for i = 1:3
  figure
  
  for j = 1:3
    
    x = spread(i)*randn(nDots,1) + center(j,1);
    y = spread(i)*randn(nDots,1) + center(j,2);
    
    plot(x,y,'.','color',color(j,:),'markersize',30)
    hold on
  end
  
  box off
  
  set(gca,'xtick',[])
  set(gca,'ytick',[])
  
  xlabel('Feature #1','fontsize',24)
  ylabel('Feature #2','fontsize',24)
  
  set(gca,'fontsize',20)
  
  fName = sprintf(fNameMask,i);
  saveas(gcf,fName,'pdf')
  
end




