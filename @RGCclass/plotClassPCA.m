% The idea is to check whether a class is distinct or consists of
% two groups

function plotClassPCA(obj)

  % For each class, do a PCA on their feature vectors and plot
  % first two components to see if there is one or two clusters.
  
  featureMat = obj.getFeatureMat(obj.allFeatureNames);
    
  nClass = max(obj.RGCtypeID);
  
  rg = RGCgui(obj);
  
  for i = 1:nClass

    %ax(i) = subplot(3,2,i);
    f(i) = figure;
    ax(i) = gca;
    
    idx = find(obj.RGCtypeID == i);
    
    [pc,score,latent] = princomp(featureMat(idx,:));

    plot(score(:,1),score(:,2), ...
         '.', 'markersize', 30, ...
         'color', rg.classColours(i,:));

    if(i == 1)
      xlabel('PCA #1','fontsize',20)
      ylabel('PCA #2','fontsize',20)
    end

    title(obj.RGCtypeName{idx(1)},'fontsize',30)

    set(gca,'fontsize',20)
    box off
    axis equal
    axis tight

    a(i,:) = axis;
    
  end
 
  axis(ax,[min(a(:,1)),max(a(:,2)),min(a(:,3)),max(a(:,4))])
  

  for i = 1:numel(f)
    saveas(f(i),sprintf('FIGS/PCA-plot-within-class-%d',i),'pdf')
  end
  
end