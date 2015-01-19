clear all, close all
r = RGCclass(0); % 0 means load nothing
                 % r.featuresUsed = {'dendriticField','dendriticDensity','stratificationDepthScaled', 'somaArea','fractalDimensionBoxCounting','biStratificationDistance'};
% This doesnt use VAChTband info
% r.featuresUsed = {'dendriticField','dendriticDensity','stratificationDepth', 'somaArea','fractalDimensionBoxCounting','biStratificationDistance'};

% r.featuresUsed = {'dendriticField','biStratificationDistance','fractalDimensionBoxCounting'}

% r.featuresUsed = r.allFeatureNames;

% r.featuresUsed = {'biStratificationDistance', ...
%                   'dendriticDensity', ...
%                   'dendriticField', ...
%                   'meanSegmentTortuosity', ...
%                   'somaArea', ...
%                   'stratificationDepth', ...
%                   'totalDendriticLength' };


% r.featuresUsed = {'biStratificationDistance', ...
%                   'dendriticDensity', ...
%                   'dendriticField', ...
%                   'meanBranchAngle', ...
%                   'meanSegmentTortuosity', ...
%                   'somaArea', ...
%                   'stratificationDepth', ...
%                   'totalDendriticLength' };
 
% featuresUsed = { 'dendriticDensity', ...
%                  'somaArea', ...
%                  'totalDendriticLength', ...
%                  'meanTerminalSegmentLength' };

%featuresUsed = { 'dendriticDensity', ...
%                 'somaArea', ...
%                 'dendriticField', ...
%                 'biStratificationDistance'};

featuresUsed = { 'fractalDimensionBoxCounting', ...
                 'somaArea', ...
                 'meanTerminalSegmentLength' };


plotFeatureIdx = [14 10 6]; %[3 14 4];

r.lazyLoad(); % Load previously cached data
% r.featureSelection();

r.setFeatureMat(featuresUsed);
r.trainingIdx = setdiff(1:numel(r.RGC), ceil(numel(r.RGC)*rand(20,1)));

rGUI = RGCgui(r);
setupGUI(rGUI);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% First we need to determine how many clusters we should have
% Here we use the silhouette measure

k = r.optimizeBlindClusterNumber(2:20);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% k = 5;
clusterID = r.blindClustering(k);

uIDmarker = unique(r.RGCtypeID);
uIDblind = unique(clusterID);

membershipTable = zeros(numel(uIDmarker), ...
                        numel(uIDblind));

for i = 1:numel(uIDmarker)
  for j = 1:numel(uIDblind)
    membershipTable(i,j) = numel(find(r.RGCtypeID == uIDmarker(i) ...
                                      & clusterID == uIDblind(j)));
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

typeCol = [228,26,28 ;...
           55,126,184;...
           77,175,74;...
           152,78,163;...
           255,127,0] / 255;

altCol = [102,194,165; ...
          252,141,98; ...
          141,160,203; ...
          231,138,195; ...
          166,216,84] / 255;

% Plot how many members of each blind class the original subtypes have

figure
for i = 1:numel(uIDmarker)
  subplot(ceil((1+numel(uIDmarker))/2), 2, i)
  bar(1:numel(uIDblind), membershipTable(i,:), ...
      'facecolor', typeCol(i,:), ...
      'edgecolor', typeCol(i,:))
  str = sprintf('%s (n = %d)', ...
                r.RGCtypeName{find(r.RGCtypeID == uIDmarker(i),1)}, ...
                nnz(r.RGCtypeID == uIDmarker(i)));
  title(str)
end

subplot(ceil((1+numel(uIDmarker))/2), 2, numel(uIDmarker) + 1)
bar(1:numel(uIDblind),sum(membershipTable,1),'facecolor','black','edgecolor','black')
title('Total # members for blind classes')

% Plot the feature space with the different clusters coloured

figure


x = r.getVariable(r.allFeatureNames{plotFeatureIdx(1)});
y = r.getVariable(r.allFeatureNames{plotFeatureIdx(2)});
z = r.getVariable(r.allFeatureNames{plotFeatureIdx(3)});

subplot(2,2,1)
for i = 1:numel(r.RGC)
  plot3(x(i),y(i),z(i),'.','color',typeCol(r.RGC(i).typeID,:))
  hold on
end

title('Marker ID')
xlabel(r.allFeatureNames{plotFeatureIdx(1)});
ylabel(r.allFeatureNames{plotFeatureIdx(2)});
zlabel(r.allFeatureNames{plotFeatureIdx(3)});

subplot(2,2,2)
for i = 1:numel(r.RGC)
  plot3(x(i),y(i),z(i),'.','color',altCol(clusterID(i),:))
  hold on
end
title('Blind classification')

xlabel(r.allFeatureNames{plotFeatureIdx(1)});
ylabel(r.allFeatureNames{plotFeatureIdx(2)});
zlabel(r.allFeatureNames{plotFeatureIdx(3)});




r.plotFeatures(r.featuresUsed)
