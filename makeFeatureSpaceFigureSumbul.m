clear all, close all
r = RGCclass(0); r.lazyLoad('knownSumbul');

classificationType = 'leaveoneout'; % 'crossvalidation'

rng('shuffle')

switch(classificationType)
  
  case 'crossvalidation'
    
    kFold = 5;
    nRep = 1000;

    fprintf('Running %d classifications (be patient)\n', nRep)
    [modalClassID,ID] = r.foldedClassification(kFold,nRep);

    predictedID = modalClassID;
    
  case 'leaveoneout'

    predictedID = r.leaveOneOutClassification();
    
  otherwise
    
    fprintf('Unknown classification type: %s\n', classificationType)
    return
end

% r.plotSpace({'fractalDimensionBoxCounting', 'somaArea'},modalClassID);
% r.plotSpace({'fractalDimensionBoxCounting', 'meanTerminalSegmentLength'},modalClassID);

% r.plotSpace({'fractalDimensionBoxCounting', 'somaArea'},modalClassID);
% r.plotSpace({'fractalDimensionBoxCounting', 'meanTerminalSegmentLength'},modalClassID);

% Saves figures
% r.plotSpace({'fractalDimensionBoxCounting', 'somaArea'},predictedID,true);
% r.plotSpace({'dendriticField', 'meanTerminalSegmentLength'},predictedID,false);
% r.plotSpace({'fractalDimensionBoxCounting', 'densityOfBranchPoints'},predictedID,false);


% Update, make one big figure

figure
set(gcf,'papertype','a4')
sp(1) = subplot(3,1,1);
r.plotSpace({'biStratificationDistance', 'stratificationDepth'},predictedID,true, true);
pbaspect(gca,[1 1 1])
legend boxoff

a = axis();
a(1) = 0; a(3) = 0;
axis(a);

ax(1) = gca;

text(a(1) - 0.4 * (a(2)-a(1)), ...
     a(4) + 0.01 * (a(4)-a(3)),char('A'), ...
     'fontsize', 18)

% Hard coding the ticks
%set(gca,'ytick',[0:100:600])
%set(gca,'yticklabel',{'0','','','','','','600'})
%set(gca,'xtick',[0:5000:15000])
%set(gca,'xticklabel',{'0','','','15,000'})


sp(2) = subplot(3,1,2);
r.plotSpace({'densityOfBranchPoints', 'totalDendriticLength'},predictedID,false, true);
pbaspect(gca,[1 1 1])
% legend boxoff

a = axis();
a(1) = 0; a(3) = 0;
axis(a);

ax(2) = gca;

text(a(1) - 0.4 * (a(2)-a(1)), ...
     a(4) + 0.01 * (a(4)-a(3)),char('B'), ...
     'fontsize', 18)

% Hard coding the ticks
%set(gca,'ytick',[0:100:600])
%set(gca,'yticklabel',{'0','','','','','','600'})
%set(gca,'xtick',[0:5000:15000])
%set(gca,'xticklabel',{'0','','','15,000'})



sp(3) = subplot(3,1,3);
r.plotSpace('pca',predictedID,false, true);
set(gca,'xtick',[-5 0 5])
set(gca,'ytick',[-4 0 4])

%axis equal
ax(3) = gca;
pbaspect(gca,[1 1 1])

set(gcf,'paperunits','centimeters')
set(gcf,'paperposition',[0 0 6 18])

set(ax(1),'position',[0.25 0.6 0.55 0.55])
set(ax(2),'position',[0.25 0.35 0.55 0.55])
set(ax(3),'position',[0.25 0.1 0.55 0.55])


ch = get(gcf,'children');
leg = ch(3); % Legend

% pos = get(leg,'position');
pos = [0.75 0.9 0.01 0.01];
set(leg,'fontsize',6)
set(leg,'position',pos)


a = axis();
text(a(1) - 0.6 * (a(2)-a(1)), ...
     a(4)+ 0.01 * (a(4)-a(3)),char('C'), ...
     'fontsize', 18)


printA4('FIGS/PlotSpace-for-article-summary-knownSumbul.eps')