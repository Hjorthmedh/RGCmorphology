% This code loads the Sumbul features and saves a mat file
%
% We then want to
% 1. Do hierarchical clustering, see if we can get the results that
% Sumbul get
% 2. Do blind clustering with k-means and their features, see how
% well we can do.
% 3. Do blind clustering with k-means using our set of features on
% the Sumbul data set.
%
% Q: How well can we do classification without the stratification information?

clear all, close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileA = '/Users/hjorth/DATA/Sumbul/rgc-master/arborDensities20x20x120_cells1to91.mat';
fileB = '/Users/hjorth/DATA/Sumbul/rgc-master/arborDensities20x20x120_cells92to182.mat';
fileC = '/Users/hjorth/DATA/Sumbul/rgc-master/arborDensities20x20x120_cells183to273.mat';
fileD = '/Users/hjorth/DATA/Sumbul/rgc-master/arborDensities20x20x120_cells274to363.mat';

dataA = load(fileA);
dataB = load(fileB);
dataC = load(fileC);
dataD = load(fileD);

allDist = [dataA.allDist_1to91, dataB.allDist_92to182, ...
           dataC.allDist_183to273, dataD.allDist_274to363];

clear dataA dataB dataC dataD

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileX = '/Users/hjorth/DATA/Sumbul/rgc-master/warpedArbors1.mat';
fileY = '/Users/hjorth/DATA/Sumbul/rgc-master/warpedArbors2.mat';
fileZ = '/Users/hjorth/DATA/Sumbul/rgc-master/warpedArbors3.mat';

dataX = load(fileX);
dataY = load(fileY);
dataZ = load(fileZ);

arborTraces = [dataX.arborTraces1; dataY.arborTraces2; ...
               dataZ.arborTraces3];

for i = 1:numel(arborTraces)
  geneticLine{i} = arborTraces{i}.geneticLine;
end

clear dataX dataY dataZ

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  nameList = {'CB2', ...
              'Cdh3', ...
              'DRD4', ... 
              'Hoxd10', ... 
              'TRHR', ...
              'BD', ...
              'JAM-B', ...
              'K', ...
              'W3', ...
              'W7'}; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r = RGCclass(0);

r.allFeatureNames = {};

r.featuresUsed = {};
for i = 1:size(allDist,1)
  r.featuresUsed{i} = num2str(i);
end

r.featureMat = transpose(allDist);

r.RGCtypeID = [];
r.RGCtypeName = {};

r.RGC = NaN*ones(numel(geneticLine),1);

for i = 1:numel(geneticLine)
  
  idx = ismember(nameList,geneticLine{i});
  
  if(all(idx == 0))
    r.RGCtypeID(i,1) = -1;
  else
    r.RGCtypeID(i,1) = find(idx);
  end
  r.RGCtypeName{i,1} = geneticLine{i};
  
end

r.lazySave('SumbulFeatures');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lets do a test case -- this throws away the unclassified cells

if(0)
  cIdx = find(r.RGCtypeID > 0);
  r.featureMat = r.featureMat(cIdx,:);
  r.RGCtypeID = r.RGCtypeID(cIdx);
  r.RGCtypeName = r.RGCtypeName(cIdx);
  r.RGC = r.RGC(cIdx);
  
  disp('Trying Naive bayes on all these features')
  tic
  [corrFraction,corrFractionSD,correctFraction, ...
         classifiedID,correctFlag, mu, sigma, dataIdx] = r.benchmark(1,[],1); % Dont recalculate features
  toc
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(1)

  myLinkage = elinkage(pdist(allDist','euclidean'));
  myLinkage(:,3) = myLinkage(:,3)/myLinkage(end,3);

  figure
  h = dendrogram(myLinkage,0);

end


  