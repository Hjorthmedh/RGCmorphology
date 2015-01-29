% This script picks out missclassified neurons

close all, clear all

RGCused = {};

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

useLeaveOneOutForAll = true;

if(useLeaveOneOutForAll)
  [classID,postP] = r.predictionPosteriorProbabilitiesLeaveOneOut();

  uID = unique(r.RGCtypeID);
  mIdx = zeros(numel(uID),1);
  
  for i = 1:numel(uID)
    thisIdx = find(uID(i) == r.RGCtypeID);
    [m,maxIdx] = max(postP(thisIdx));
    mIdx(i) = thisIdx(maxIdx(1));
  end

else
  [postp,cIdx,logP] = r.classifier.posterior(r.featureMat);

  % mIdx is the best matching neuron of that class
  [m,mIdx] = max(postp);

end

a = [];
fig = [];

% Draw the typical neurons %%%%%%%%%%%%%

for i = 1:numel(mIdx)
  
  idx = mIdx(i);
  r.RGC(idx).drawNeuron(1,1,[],0,0.5)
  
  RGCused{end+1} = r.RGC(idx).xmlFile;
  
  % Make sure each member is of that particular class
  assert(r.RGCtypeID(idx) == i)
  
  fig(i) = gcf;
  
  % str = sprintf('%s - %s', r.RGC(idx).typeName, r.RGC(idx).xmlFile);
  str = sprintf('%s: %s', r.RGC(idx).typeName,r.RGC(idx).typeName);
    
  title(str,'fontsize',30)
  
  a(i,:) = axis;
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[classID,postP] = r.predictionPosteriorProbabilitiesLeaveOneOut();

IDmax = max(r.RGCtypeID);

[~,sortIdx] = sort(postP,'descend');

badIdx = [];

for i = 1:IDmax % Loop through id 1,2,3,4,5
  
  idx = sortIdx(find(r.RGCtypeID(sortIdx) == i & transpose(classID(sortIdx)) ~= i,1,'first'));
  badIdx(end+1) = idx;
  
  r.RGC(idx).drawNeuron(1,1,[],0,0.5)
  figWrong(i) = gcf;

  RGCused{end+1} = r.RGC(idx).xmlFile;
  
  strReal = r.RGC(idx).typeName;
  strGuessed = r.RGCuniqueNames{classID(idx)};
  
  % str = sprintf('Predicted: %s (%.1f %%)\nReal: %s\n', ...
  %               strGuessed, 100*postP(idx), strReal);
  str = sprintf('%s: %s', ...
                strReal, strGuessed);
  
  title(str,'fontsize',30)
  
  a(i+numel(mIdx),:) = axis;
  
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Rescale axis and save the figures


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% And the bad ones

for i = 1:numel(badIdx)
  
  idx = badIdx(i);
  
 figure(figWrong(i));
  
  w = a(i+numel(mIdx),2)-a(i+numel(mIdx),1);
  h = a(i+numel(mIdx),4)-a(i+numel(mIdx),3);
  
  ax(1) = a(i+numel(mIdx),1)-(maxW-w)/2;
  ax(2) = a(i+numel(mIdx),2)+(maxW-w)/2;  
  ax(3) = a(i+numel(mIdx),3)-(maxH-h)/2;
  ax(4) = a(i+numel(mIdx),4)+(maxH-h)/2;  
  
  assert(abs(ax(2)-ax(1) - maxW) < 0.01*maxW)
  assert(abs(ax(4)-ax(3) - maxH) < 0.01*maxH)
  
  axis(ax);
    
  axis off
  
  str = sprintf('FIGS/Incorrect-%s-neuron.pdf', r.RGC(idx).typeName);
  saveas(gcf,str,'pdf')
  
  
end



disp('Files used:')

for i = 1:numel(RGCused)
  fprintf('%s\n', RGCused{i})
end
