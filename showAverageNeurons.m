% This script picks out the most central of the neurons

close all, clear all

r = RGCclass(0); r.lazyLoad();

useFeatures = { 'densityOfBranchPoints', ...
                'dendriticField', ...
                'somaArea', ...
                'fractalDimensionBoxCounting', ...
                'meanTerminalSegmentLength' };

r.setFeatureMat(useFeatures)


% Lets train with all data to find the average neuron

disp('Training with all data to find average neuron. Do not use this for classification!')
r.train(1:numel(r.RGC));

[postp,cIdx,logP] = r.classifier.posterior(r.featureMat);

% mIdx is the best matching neuron of that class
[m,mIdx] = max(postp);

a = [];
fig = [];

for i = 1:numel(mIdx)
  
  idx = mIdx(i);
  r.RGC(idx).drawNeuron()
  
  fig(i) = gcf;
  
  % Make sure each member is of that particular class
  assert(r.RGCtypeID(idx) == i)

  % str = sprintf('%s - %s', r.RGC(idx).typeName, r.RGC(idx).xmlFile);
  str = r.RGC(idx).typeName;
    
  title(str,'fontsize',30)
  
  a(i,:) = axis;
  
end

maxW = max(a(:,2) - a(:,1));
maxH = max(a(:,4) - a(:,3));

% ax(1) = min(a(:,1));
% ax(2) = max(a(:,2));
% ax(3) = min(a(:,3));
% ax(4) = max(a(:,4));

for i = 1:numel(mIdx)

  idx = mIdx(i);
  
  figure(fig(i));
  
  w = a(i,2)-a(i,1);
  h = a(i,4)-a(i,3);
  
  ax(1) = a(i,1)-(maxW-w)/2;
  ax(2) = a(i,2)+(maxW-w)/2;  
  ax(3) = a(i,3)-(maxH-h)/2;
  ax(4) = a(i,4)+(maxH-h)/2;  
  
  assert(abs(ax(2)-ax(1) - maxW) < 0.01*maxW)
  assert(abs(ax(4)-ax(3) - maxH) < 0.01*maxH)
  
  axis(ax);
  
  if(i == 1)
    hold on
    plot([300 400],[0 0],'k-','linewidth',2)
    text(300,-20,' 100 \mum','fontsize',20)
  end
  
  axis off
  
  str = sprintf('FIGS/Typical-%s-neuron.pdf', r.RGC(idx).typeName);
  saveas(gcf,str,'pdf')

end